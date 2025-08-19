import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/model/result.dart';
import '../../../data/ui_state/status.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/toast_messages.dart';
import '../../profile/cubit/profile/profile_cubit.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../model/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingPreview = false;
  String? _currentPlayingPath;
  bool _isLoadingHistory = false;
  bool _showLanguageOptions =
      false; // Flag to prevent multiple pagination calls
  final profileCubit = locator<ProfileCubit>();

  @override
  void initState() {
    super.initState();
    // Listen to audio player state changes
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlayingPreview = state.playing;
        });

        // Reset when audio completes
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlayingPreview = false;
            _currentPlayingPath = null;
          });
        }
      }
    });

    // Add scroll listener for automatic pagination
    _scrollController.addListener(_onScroll);

    // Load initial chat history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().loadChatHistory(refresh: true);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Handle scroll events for automatic pagination
  void _onScroll() {
    // Only trigger when scrolled near the very top
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 100) {
      final chatCubit = context.read<ChatCubit>();

      // Check if we can load more and aren't already loading
      if (chatCubit.state.hasMoreMessages &&
          !chatCubit.state.isLoading &&
          !_isLoadingHistory) {
        // Store current scroll position before loading
        final currentScrollPosition = _scrollController.position.pixels;
        final currentMaxScrollExtent =
            _scrollController.position.maxScrollExtent;

        // Set loading flag to prevent multiple calls
        _isLoadingHistory = true;

        // Load more messages
        chatCubit
            .loadMoreChatHistory()
            .then((_) {
              // After loading, adjust scroll position to maintain user's view
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  final newMaxScrollExtent =
                      _scrollController.position.maxScrollExtent;
                  final scrollOffset =
                      newMaxScrollExtent - currentMaxScrollExtent;

                  // Adjust scroll position to account for new content added at top
                  if (scrollOffset > 0) {
                    _scrollController.jumpTo(
                      currentScrollPosition + scrollOffset,
                    );
                  }
                }
              });
              // Reset loading flag
              _isLoadingHistory = false;
            })
            .catchError((error) {
              // Reset loading flag on error
              _isLoadingHistory = false;
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light gray background
      appBar: _buildAppBar(),
      body: SafeArea(
        child: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.red,
                ),
              );
              context.read<ChatCubit>().clearError();
            }

            // Auto scroll to bottom when new message added (but not during pagination)
            if (!_isLoadingHistory && state.pageNo == 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // Messages List
                Expanded(child: _buildMessagesList(state.messages)),

                // Recording Indicator or Audio Preview
                if (state.isRecording) _buildRecordingIndicator(state),
                if (state.recordedAudioPath != null) _buildAudioPreview(state),

                // Input Area (hide when audio is recorded or processing voice)
                // if (state.recordedAudioPath == null && !state.isProcessingVoice) _buildInputArea(state),
                if (state.recordedAudioPath == null) _buildInputArea(state),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'AI Chatbot',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        // Headset Icon
        GestureDetector(
          onTap: () {
            commonSupportDialog(
              context,
              message: context.appText.callCustomerSupportSubtitle,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(AppImage.png.customerSupport, height: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesList(List<ChatMessage> messages) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        // Show loading indicator if no messages and still loading
        if (messages.isEmpty && state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show default greeting only if no messages and not loading
        List<ChatMessage> displayMessages =
            messages.isEmpty && !state.isLoading
                ? [
                  ChatMessage(
                    id: 'greeting',
                    message: 'Hello! How Can i Help you?',
                    isUser: false,
                    timestamp: DateTime.now(),
                    language: 'en',
                    messageType: MessageType.text,
                  ),
                ]
                : messages;

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount:
              displayMessages.length +
              (state.isTyping ? 1 : 0) +
              (state.hasMoreMessages ? 1 : 0) +
              (state.isProcessingVoice ? 2 : 0),
          itemBuilder: (context, index) {
            if (index == 0 && state.hasMoreMessages) {
              // Show loading indicator at top when loading more
              return _buildTopLoadingIndicator();
            } else if (index <
                displayMessages.length + (state.hasMoreMessages ? 1 : 0)) {
              // Messages (adjust index for loading indicator)
              final messageIndex = index - (state.hasMoreMessages ? 1 : 0);
              if (messageIndex >= 0 && messageIndex < displayMessages.length) {
                return _buildMessageBubble(displayMessages[messageIndex]);
              }
            } else if (index ==
                    displayMessages.length + (state.hasMoreMessages ? 1 : 0) &&
                state.isTyping &&
                !state.isProcessingVoice) {
              // Show typing indicator as last item
              return _buildTypingIndicator();
            } else if (state.isProcessingVoice) {
              // Show voice processing indicators
              final processingIndex =
                  index -
                  displayMessages.length -
                  (state.isTyping ? 1 : 0) -
                  (state.hasMoreMessages ? 1 : 0);
              if (processingIndex == 0) {
                // Show "Transcribing..." message (user side)
                return _buildTranscribingMessage();
              } else if (processingIndex == 1) {
                // Show "AI is thinking..." message (AI side)
                return _buildTypingIndicator();
              }
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    final isVoice = message.messageType == MessageType.voice;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[_buildAvatarIcon(false), const SizedBox(width: 8)],

          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primaryColor : Colors.white,
                // Blue for user, white for AI
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft:
                      isUser
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                  bottomRight:
                      isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isVoice)
                    _buildVoiceMessage(message.message)
                  else
                    Text(
                      message.message,
                      style: TextStyle(
                        fontSize: 16,
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: isUser ? AppColors.white : AppColors.grayColor,
                        ),
                      ),
                      if (!isUser && !isVoice) ...[
                        const SizedBox(width: 8),
                        // Language indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.grayColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getLanguageDisplayName(message.language),
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.grayColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Speaker icon for AI text responses
                        GestureDetector(
                          onTap: () {
                            if (message.isPlaying) {
                              // Stop current audio if this message is playing
                              _audioPlayer.stop();
                              setState(() {
                                message.isPlaying = false;
                                _isPlayingPreview = false;
                              });
                            } else {
                              // Play audio for this message
                              _playTextToSpeech(message);
                            }
                          },
                          child: Icon(
                            message.isPlaying ? Icons.stop : Icons.volume_up,
                            size: 16,
                            color:
                                message.isPlaying
                                    ? AppColors.red
                                    : AppColors.grayColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (isUser) ...[const SizedBox(width: 8), _buildAvatarIcon(true)],
        ],
      ),
    );
  }

  Widget _buildAvatarIcon(bool isUser) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: profileCubit,
      listener: (context, state) {
        final status = state.profileDetailUIState?.status;

        if (status == Status.ERROR) {
          final error = state.profileDetailUIState?.errorType;
          ToastMessages.error(
            message: getErrorMsg(errorType: error ?? GenericError()),
          );
        }
      },
      builder: (context, state) {
        if (state.profileDetailUIState != null &&
            state.profileDetailUIState?.status == Status.SUCCESS) {
          if (state.profileDetailUIState?.data != null &&
              state.profileDetailUIState?.data?.customer != null) {
            return Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child:
                    isUser
                        ? Text(
                          getInitialsFromName(
                            this,
                            name:
                                state
                                    .profileDetailUIState!
                                    .data!
                                    .customer!
                                    .companyName,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                        : SvgPicture.asset(
                          'assets/icons/svg/chatIcon.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
              ),
            );
          }
        }
        return Text(
          getInitialsFromName(this, name: 'You'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );

    // return Container(
    //   width: 36,
    //   height: 36,
    //   decoration: BoxDecoration(
    //     color: isUser ? const Color(0xFF4285F4) : const Color(0xFF4285F4),
    //     shape: BoxShape.circle,
    //   ),
    //   child: Center(
    //     child: isUser
    //       ? Text(
    //           'V',
    //           style: TextStyle(
    //             color: Colors.white,
    //             fontSize: 16,
    //             fontWeight: FontWeight.w600,
    //           ),
    //         )
    //       : SvgPicture.asset(
    //           'assets/icons/svg/chatIcon.svg',
    //           width: 24,
    //           height: 24,
    //           colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    //         ),
    //   ),
    // );
  }

  Widget _buildVoiceMessage(String audioPath) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 8),
              const Icon(Icons.mic, size: 16, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                'Voice Message',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Audio Progress Slider
          StreamBuilder<Duration>(
            stream: _audioPlayer.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _audioPlayer.duration ?? Duration.zero;
              final isCurrentPlaying = _currentPlayingPath == audioPath;
              final progress =
                  isCurrentPlaying && duration.inMilliseconds > 0
                      ? position.inMilliseconds / duration.inMilliseconds
                      : 0.0;

              return Row(
                children: [
                  // Play/Pause button
                  IconButton(
                    icon: Icon(
                      (_isPlayingPreview && _currentPlayingPath == audioPath)
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: AppColors.white,
                      size: 24,
                    ),
                    onPressed: () async {
                      if (_isPlayingPreview &&
                          _currentPlayingPath == audioPath) {
                        await _pauseAudio();
                      } else {
                        await _playRecordedAudio(audioPath);
                      }
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primaryColor.withValues(
                        alpha: 0.2,
                      ),
                      shape: const CircleBorder(),
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                        thumbColor: Colors.white,
                        overlayColor: Colors.white.withValues(alpha: 0.2),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        trackHeight: 3,
                      ),
                      child: Slider(
                        value: progress.clamp(0.0, 1.0),
                        onChanged: (value) {
                          if (isCurrentPlaying) {
                            final seekPosition = Duration(
                              milliseconds:
                                  (value * duration.inMilliseconds).round(),
                            );
                            _audioPlayer.seek(seekPosition);
                          }
                        },
                        onChangeStart: (value) {
                          // Pause during seeking for better UX
                          if (isCurrentPlaying && _audioPlayer.playing) {
                            _audioPlayer.pause();
                          }
                        },
                        onChangeEnd: (value) {
                          // Resume playing after seeking if it was playing before
                          if (isCurrentPlaying && _isPlayingPreview) {
                            _audioPlayer.play();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isCurrentPlaying
                        ? '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}'
                        : '0:00',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingIndicator(ChatState state) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          // Animated recording indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recording...',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.recordingDuration}s / 15s${state.recordingDuration >= 12 ? ' (stopping soon)' : ''}',
                  style: TextStyle(
                    color:
                        state.recordingDuration >= 12
                            ? Colors.red[900]
                            : Colors.red[700],
                    fontSize: 12,
                    fontWeight:
                        state.recordingDuration >= 12
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: state.recordingDuration / 15.0,
                  backgroundColor: Colors.red[100],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    state.recordingDuration >= 12
                        ? Colors.red[900]!
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: () {
              context.read<ChatCubit>().cancelRecording();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPreview(ChatState state) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mic, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Voice Message (${state.recordingDuration}s)',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Waveform visualization with playback indicator
          // Audio Progress Slider
          StreamBuilder<Duration>(
            stream: _audioPlayer.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _audioPlayer.duration ?? Duration.zero;
              final progress =
                  duration.inMilliseconds > 0
                      ? position.inMilliseconds / duration.inMilliseconds
                      : 0.0;

              return Row(
                children: [
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primaryColor,
                        inactiveTrackColor: Colors.grey[300],
                        thumbColor: AppColors.primaryColor,
                        overlayColor: AppColors.primaryColor.withValues(
                          alpha: 0.2,
                        ),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: progress.clamp(0.0, 1.0),
                        onChanged: (value) {
                          final seekPosition = Duration(
                            milliseconds:
                                (value * duration.inMilliseconds).round(),
                          );
                          _audioPlayer.seek(seekPosition);
                        },
                        onChangeStart: (value) {
                          // Pause during seeking for better UX
                          if (_audioPlayer.playing) {
                            _audioPlayer.pause();
                          }
                        },
                        onChangeEnd: (value) {
                          // Resume playing after seeking if it was playing before
                          if (_isPlayingPreview) {
                            _audioPlayer.play();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                    // '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}/${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              );
            },
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              // Play/Pause button
              IconButton(
                onPressed: () async {
                  if (state.recordedAudioPath != null) {
                    if (_isPlayingPreview &&
                        _currentPlayingPath == state.recordedAudioPath) {
                      await _pauseAudio();
                    } else {
                      await _playRecordedAudio(state.recordedAudioPath!);
                    }
                  }
                },
                icon: Icon(
                  (_isPlayingPreview &&
                          _currentPlayingPath == state.recordedAudioPath)
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.blue[600],
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue[100],
                  shape: const CircleBorder(),
                ),
              ),
              const SizedBox(width: 8),
              // Delete button
              IconButton(
                onPressed: () async {
                  // Stop audio if playing
                  if (_isPlayingPreview) {
                    await _audioPlayer.stop();
                  }

                  // Reset audio player state
                  setState(() {
                    _isPlayingPreview = false;
                    _currentPlayingPath = null;
                  });

                  context.read<ChatCubit>().deleteRecordedAudio();
                  // Clear text controller as well
                  _textController.clear();
                  setState(() {}); // Force UI refresh
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  shape: const CircleBorder(),
                ),
              ),
              const Spacer(),
              // Send button
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, chatState) {
                  final isWaitingForResponse =
                      chatState.isTyping || chatState.isLoading;
                  final canSend = !isWaitingForResponse;

                  return ElevatedButton.icon(
                    onPressed:
                        canSend
                            ? () {
                              context.read<ChatCubit>().sendRecordedAudio();
                              // Reset audio player state
                              if (_isPlayingPreview) {
                                _audioPlayer.stop();
                                setState(() {
                                  _isPlayingPreview = false;
                                  _currentPlayingPath = null;
                                });
                              }
                            }
                            : null, // Disable when waiting for response
                    icon: Icon(
                      isWaitingForResponse ? Icons.hourglass_empty : Icons.send,
                      size: 18,
                    ),
                    label: Text(isWaitingForResponse ? 'Sending...' : 'Send'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          canSend ? AppColors.primaryColor : Colors.grey[400],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(ChatState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        children: [
          // Floating language options (positioned at screen level)
          _showLanguageOptions
              ? Expanded(child: _buildFloatingLanguageOptions())
              : Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, chatState) {
                      final isWaitingForResponse =
                          chatState.isTyping || chatState.isLoading;
                      final isDisabled =
                          state.isRecording ||
                          state.recordedAudioPath != null ||
                          isWaitingForResponse;
                      return TextField(
                        controller: _textController,
                        enabled: !isDisabled,
                        // Disable when recording, preview, or waiting for response
                        decoration: InputDecoration(
                          hintText:
                              state.isRecording
                                  ? 'Recording...'
                                  : state.recordedAudioPath != null
                                  ? 'Audio recorded'
                                  : isWaitingForResponse
                                  ? (state.isProcessingVoice
                                      ? 'Transcribing...'
                                      : 'AI is responding...')
                                  : 'Type here',
                          hintStyle: TextStyle(
                            color: isDisabled ? Colors.grey[400] : Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {}); // Update send button state
                        },
                      );
                    },
                  ),
                ),
              ),

          const SizedBox(width: 8),

          // Voice Button
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, chatState) {
              final isWaitingForResponse =
                  chatState.isTyping || chatState.isLoading;
              final canRecord =
                  !isWaitingForResponse &&
                  state.recordedAudioPath == null &&
                  !state.isProcessingVoice;

              return GestureDetector(
                onTap:
                    canRecord
                        ? () {
                          if (state.isRecording) {
                            context.read<ChatCubit>().stopRecording();
                          } else if (_showLanguageOptions) {
                            // Hide language options (cancel)
                            setState(() {
                              _showLanguageOptions = false;
                            });
                          } else {
                            // Show floating language options

                            setState(() {
                              _showLanguageOptions = true;
                            });
                          }
                        }
                        : null,
                // Disable when waiting for response or when audio is recorded
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        state.isRecording
                            ? Colors.red
                            : state.recordedAudioPath != null
                            ? Colors.blue[300]
                            : canRecord
                            ? Colors.grey[400]
                            : Colors.grey[300], // Lighter grey when disabled
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    state.isRecording
                        ? Icons.stop
                        : _showLanguageOptions
                        ? Icons.close
                        : Icons.mic,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 8),

          // Send Button (only show for text, not for voice)
          if (_textController.text.trim().isNotEmpty &&
              state.recordedAudioPath == null)
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, chatState) {
                final isWaitingForResponse =
                    chatState.isTyping || chatState.isLoading;
                final canSend = !isWaitingForResponse;

                return GestureDetector(
                  onTap:
                      canSend
                          ? () {
                            final text = _textController.text.trim();
                            if (text.isNotEmpty) {
                              context.read<ChatCubit>().sendTextMessage(text);
                              _textController.clear();
                              setState(() {}); // Update UI
                            }
                          }
                          : null, // Disable when waiting for response
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          canSend
                              ? AppColors.primaryColor
                              : Colors.grey[400], // Grey when disabled
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isWaitingForResponse ? Icons.hourglass_empty : Icons.send,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  /// Build floating language options (horizontal layout)
  Widget _buildFloatingLanguageOptions() {
    return Positioned(
      bottom: 120, // Position higher above the input area
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // English option
            _buildFloatingLanguageButton(
              ChatLanguage.english,
              'English',
              Icons.language,
              Colors.blue[600]!,
            ),
            // Hindi option
            _buildFloatingLanguageButton(
              ChatLanguage.hindi,
              'हिंदी',
              Icons.language,
              Colors.orange[600]!,
            ),
            // Tamil option
            _buildFloatingLanguageButton(
              ChatLanguage.tamil,
              'தமிழ்',
              Icons.language,
              Colors.green[600]!,
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual floating language button
  Widget _buildFloatingLanguageButton(
    ChatLanguage language,
    String label,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        // Hide options
        setState(() {
          _showLanguageOptions = false;
        });

        // Update language and start recording
        final cubit = context.read<ChatCubit>();
        cubit.changeLanguage(language);
        cubit.startRecording();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopLoadingIndicator() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        // Show loading only when actually loading history
        if (_isLoadingHistory || state.isLoading) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue[600]!,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Loading older messages...',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTranscribingMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  16,
                ).copyWith(bottomRight: const Radius.circular(4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pulsing mic icon
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.5, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Icon(
                          Icons.mic,
                          size: 16,
                          color: AppColors.primaryColor.withValues(
                            alpha: value,
                          ),
                        ),
                      );
                    },
                    onEnd: () {
                      // Restart animation
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Transcribing',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Loading dots
                  _buildLoadingDots(AppColors.primaryColor),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildAvatarIcon(true),
        ],
      ),
    );
  }

  Widget _buildLoadingDots(Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.3, end: 1.0),
          duration: Duration(milliseconds: 600 + (index * 200)),
          builder: (context, value, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: Opacity(
                opacity: value,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
          onEnd: () {
            // Restart animation
            setState(() {});
          },
        );
      }),
    );
  }

  Widget _buildTypingIndicator() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, chatState) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatarIcon(false),
              const SizedBox(width: 8),

              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomLeft: const Radius.circular(4),
                      bottomRight: const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: _buildTypingDots(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypingDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 600 + (index * 200)),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final timeString = '$hour:$minute';

    if (difference.inDays > 0) {
      // Show full date with time for older messages
      return '${dateTime.day} ${_getMonthName(dateTime.month)}, ${dateTime.year} $timeString';
    } else {
      // Show date and time for today's messages
      return '${dateTime.day} ${_getMonthName(dateTime.month)} $timeString';
    }
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  /// Get language display name from language code
  String _getLanguageDisplayName(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
      case 'en-in':
        return 'EN';
      case 'hi':
      case 'hi-in':
        return 'हि';
      case 'ta':
      case 'ta-in':
        return 'த';
      default:
        return 'EN';
    }
  }

  /// Validate and normalize language code for TTS API
  /// Returns valid language code or defaults to 'en-IN' for unsupported languages
  String _getValidLanguageForTTS(String languageCode) {
    final normalizedCode = languageCode.toLowerCase();
    
    // Check for supported languages
    switch (normalizedCode) {
      case 'en':
      case 'en-in':
        return 'en-IN';
      case 'hi':
      case 'hi-in':
        return 'hi-IN';
      case 'ta':
      case 'ta-in':
        return 'ta-IN';
      default:
        // For any other language, default to English
        return 'en-IN';
    }
  }

  /// Play text-to-speech audio
  Future<void> _playTextToSpeech(ChatMessage message) async {
    try {
      // First, stop any currently playing audio and reset all messages' playing state
      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }

      // Reset all messages' playing state
      setState(() {
        final chatState = context.read<ChatCubit>().state;
        for (var msg in chatState.messages) {
          msg.isPlaying = false;
        }
        // Set the current message as playing
        message.isPlaying = true;
        _isPlayingPreview = true;
      });

      // Call the cubit to synthesize text to speech with validated language code
      final cubit = context.read<ChatCubit>();
      final validatedLanguage = _getValidLanguageForTTS(message.language);
      final audioBytes = await cubit.synthesizeTextToSpeech(
        message.message,
        language: validatedLanguage,
      );

      if (audioBytes.isNotEmpty) {
        // Convert base64 audio bytes to temporary file and play
        final tempDir = await getTemporaryDirectory();
        final tempFile = File(
          '${tempDir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.ogg',
        );
        // Write base64 decoded audio bytes to temporary file
        await tempFile.writeAsBytes(base64Decode(audioBytes));

        // Play the temporary audio file
        await _audioPlayer.setFilePath(tempFile.path);
        await _audioPlayer.play();

        // Clean up temporary file after playback
        _audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            if (mounted) {
              setState(() {
                message.isPlaying = false;
                _isPlayingPreview = false;
              });
            }
            tempFile.delete();
          }
        });
      } else {
        throw Exception('No audio data received');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to play text-to-speech: $e'),
            backgroundColor: Colors.red,
          ),
        );
        // Reset playing state
        setState(() {
          message.isPlaying = false;
          _isPlayingPreview = false;
        });
      }
    }
  }

  Future<void> _playRecordedAudio(String audioPath) async {
    try {
      // Check if file exists
      final file = File(audioPath);
      if (!await file.exists()) {
        throw Exception('Audio file not found at: $audioPath');
      }
      // If playing a different audio, stop and set new source
      if (_currentPlayingPath != audioPath) {
        await _audioPlayer.stop();
        await _audioPlayer.setFilePath(audioPath);
        _currentPlayingPath = audioPath;
      }
      // Play the audio
      await _audioPlayer.play();
      setState(() {
        _isPlayingPreview = true;
      });
    } catch (e) {
      setState(() {
        _isPlayingPreview = false;
        _currentPlayingPath = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to play audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pauseAudio() async {
    try {
      await _audioPlayer.pause();
      setState(() {
        _isPlayingPreview = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pause audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
