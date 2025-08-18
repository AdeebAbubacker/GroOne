import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/extension_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../../../data/model/result.dart';
import '../../../data/ui_state/status.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_route.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/constant_variables.dart';
import '../../../utils/toast_messages.dart';
import '../../profile/cubit/profile/profile_cubit.dart';
import '../../profile/view/profile_screen.dart';
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
  bool _isLoadingHistory = false; // Flag to prevent multiple pagination calls
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
    if (_scrollController.position.pixels <= _scrollController.position.minScrollExtent + 100) {
      final chatCubit = context.read<ChatCubit>();
      
      // Check if we can load more and aren't already loading
      if (chatCubit.state.hasMoreMessages && !chatCubit.state.isLoading && !_isLoadingHistory) {
        print('📱 Triggering pagination at scroll position: ${_scrollController.position.pixels}');
        
        // Store current scroll position before loading
        final currentScrollPosition = _scrollController.position.pixels;
        final currentMaxScrollExtent = _scrollController.position.maxScrollExtent;
        
        // Set loading flag to prevent multiple calls
        _isLoadingHistory = true;
        
        // Load more messages
        chatCubit.loadMoreChatHistory().then((_) {
          // After loading, adjust scroll position to maintain user's view
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              final newMaxScrollExtent = _scrollController.position.maxScrollExtent;
              final scrollOffset = newMaxScrollExtent - currentMaxScrollExtent;
              
              print('📱 Scroll adjustment: offset=$scrollOffset, current=$currentScrollPosition');
              
              // Adjust scroll position to account for new content added at top
              if (scrollOffset > 0) {
                _scrollController.jumpTo(currentScrollPosition + scrollOffset);
              }
            }
          });
          
          // Reset loading flag
          _isLoadingHistory = false;
        }).catchError((error) {
          print('📱 Pagination error: $error');
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
      body: BlocConsumer<ChatCubit, ChatState>(
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
          if (!_isLoadingHistory && state.pageNo ==1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
        },
        builder: (context, state) {
          return Column(
          children: [
              // Messages List
              Expanded(
                child: _buildMessagesList(state.messages),
              ),
              
              // Recording Indicator or Audio Preview
              if (state.isRecording) _buildRecordingIndicator(state),
              if (state.recordedAudioPath != null) _buildAudioPreview(state),
              
              // Input Area (hide when audio is recorded)
              if (state.recordedAudioPath == null) _buildInputArea(state),
            ],
          );
        },
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
        // Language Selector
        BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<ChatLanguage>(
                  value: state.selectedLanguage,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  items: ChatLanguage.values.map((language) {
                    return DropdownMenuItem(
                      value: language,
                      child: Text(language.displayName),
                    );
                  }).toList(),
                  onChanged: (language) {
                    if (language != null) {
                      context.read<ChatCubit>().changeLanguage(language);
              }
            },
          ),
        ),
            );
          },
        ),
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Show default greeting only if no messages and not loading
        List<ChatMessage> displayMessages = messages.isEmpty && !state.isLoading
            ? [
                ChatMessage(
                  id: 'greeting',
                  message: 'Hello! How Can i Help you?',
                  isUser: false,
                  timestamp: DateTime.now(),
                  language: 'en',
                  messageType: MessageType.text,
                )
              ]
            : messages;

    return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: displayMessages.length + (state.isTyping ? 1 : 0) + (state.hasMoreMessages ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == 0 && state.hasMoreMessages) {
              // Show loading indicator at top when loading more
              return _buildTopLoadingIndicator();
            } else if (index < displayMessages.length + (state.hasMoreMessages ? 1 : 0)) {
              // Messages (adjust index for loading indicator)
              final messageIndex = index - (state.hasMoreMessages ? 1 : 0);
              if (messageIndex >= 0 && messageIndex < displayMessages.length) {
                return _buildMessageBubble(displayMessages[messageIndex]);
              }
            } else if (index == displayMessages.length + (state.hasMoreMessages ? 1 : 0) && state.isTyping) {
              // Show typing indicator as last item
              return _buildTypingIndicator();
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
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatarIcon(false),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF4285F4) : Colors.white, // Blue for user, white for AI
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
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
                                  color: isUser ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      if (!isUser && !isVoice) ...[
                        const SizedBox(width: 8),
                        // Speaker icon for AI text responses
                        GestureDetector(
                          onTap: () => message.isPlaying?null :_playTextToSpeech(message),
                          child: message.isPlaying
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                                ),
                              )
                            : Icon(
                                Icons.volume_up,
                                size: 16,
                                color: Colors.grey[600],
                            ),
                          ),
                        ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            _buildAvatarIcon(true),
          ],
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
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
        }
      },
      builder: (context, state) {
        if (state.profileDetailUIState != null && state.profileDetailUIState?.status == Status.SUCCESS) {
          if (state.profileDetailUIState?.data != null && state.profileDetailUIState?.data?.customer != null) {
            final blueId = state.profileDetailUIState!.data!.customer?.blueId;
    return Container(
                width: 36,
                height: 36,
      decoration: BoxDecoration(
                  color: isUser ? const Color(0xFF4285F4) : const Color(0xFF4285F4),
        shape: BoxShape.circle,
      ),
                child: Center(
                  child: isUser
                      ? Text(
                    getInitialsFromName(this, name : state.profileDetailUIState!.data!.customer!.companyName),
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
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
      ),
    );
  }
        }
        return Text(
          getInitialsFromName(this, name : 'You'),
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
      width: 200,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.play_arrow,
              color: Colors.blue[700],
            ),
            onPressed: () => _playVoiceMessage(audioPath),
          ),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(1),
              ),
              child: Row(
                children: List.generate(20, (index) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      height: 2,
                      decoration: BoxDecoration(
                        color: index < 8 ? Colors.blue[700] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '0:15',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
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
                  '${state.recordingDuration}s / 15s',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 12,
                ),
              ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: state.recordingDuration / 15.0,
                  backgroundColor: Colors.red[100],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
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
              Icon(
                Icons.mic,
                color: Colors.blue[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Voice Message (${state.recordingDuration}s)',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w600,
              ),
            ),
          ],
          ),
          const SizedBox(height: 12),
          // Waveform visualization with playback indicator
          SizedBox(
            height: 40,
            child: Row(
              children: List.generate(20, (index) {
                bool isActive = _isPlayingPreview && _currentPlayingPath == state.recordedAudioPath;
                bool isPlayed = isActive && index < 10; // Simulate progress
                
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    height: (index % 3 + 1) * 10.0,
                    decoration: BoxDecoration(
                      color: isPlayed 
                          ? Colors.blue[600]  // Darker blue for played portion
                          : Colors.blue[300], // Light blue for unplayed
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              // Play/Pause button
              IconButton(
                onPressed: () async {
                  if (state.recordedAudioPath != null) {
                    if (_isPlayingPreview && _currentPlayingPath == state.recordedAudioPath) {
                      await _pauseAudio();
                    } else {
                      await _playRecordedAudio(state.recordedAudioPath!);
                    }
                  }
                },
                icon: Icon(
                  (_isPlayingPreview && _currentPlayingPath == state.recordedAudioPath) 
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
                  print('Delete button pressed'); // Debug log
                  
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
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  shape: const CircleBorder(),
                ),
              ),
              const Spacer(),
              // Send button
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, chatState) {
                  final isWaitingForResponse = chatState.isTyping || chatState.isLoading;
                  final canSend = !isWaitingForResponse;
                  
                  return ElevatedButton.icon(
                    onPressed: canSend ? () {
                      print('Send button pressed'); // Debug log
                      context.read<ChatCubit>().sendRecordedAudio();
                      // Reset audio player state
                      if (_isPlayingPreview) {
                        _audioPlayer.stop();
                        setState(() {
                          _isPlayingPreview = false;
                          _currentPlayingPath = null;
                        });
                      }
                    } : null, // Disable when waiting for response
                    icon: Icon(
                      isWaitingForResponse ? Icons.hourglass_empty : Icons.send, 
                      size: 18
                    ),
                    label: Text(
                      isWaitingForResponse ? 'Sending...' : 'Send'
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canSend 
                        ? const Color(0xFF4285F4) 
                        : Colors.grey[400],
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
          // Text Input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, chatState) {
                  final isWaitingForResponse = chatState.isTyping || chatState.isLoading;
                  final isDisabled = state.isRecording || 
                                   state.recordedAudioPath != null || 
                                   isWaitingForResponse;
                  
                  return TextField(
                    controller: _textController,
                    enabled: !isDisabled, // Disable when recording, preview, or waiting for response
                decoration: InputDecoration(
                      hintText: state.isRecording 
                          ? 'Recording...' 
                          : state.recordedAudioPath != null 
                              ? 'Audio recorded'
                              : isWaitingForResponse
                                  ? 'AI is responding...'
                                  : 'Type here',
                      hintStyle: TextStyle(
                        color: isDisabled 
                            ? Colors.grey[400] 
                            : Colors.grey
                      ),
                  border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
              final isWaitingForResponse = chatState.isTyping || chatState.isLoading;
              final canRecord = !isWaitingForResponse && state.recordedAudioPath == null;
              
              return GestureDetector(
                onTap: canRecord ? () {
                  if (state.isRecording) {
                    context.read<ChatCubit>().stopRecording();
                  } else {
                    context.read<ChatCubit>().startRecording();
                  }
                } : null, // Disable when waiting for response or when audio is recorded
                child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                    color: state.isRecording 
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
          if (_textController.text.trim().isNotEmpty && state.recordedAudioPath == null)
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, chatState) {
                final isWaitingForResponse = chatState.isTyping || chatState.isLoading;
                final canSend = !isWaitingForResponse;
                
                return GestureDetector(
                  onTap: canSend ? () {
                    final text = _textController.text.trim();
                    if (text.isNotEmpty) {
                      context.read<ChatCubit>().sendTextMessage(text);
                      _textController.clear();
                      setState(() {}); // Update UI
                    }
                  } : null, // Disable when waiting for response
                  child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                      color: canSend 
                        ? const Color(0xFF4285F4)
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Loading older messages...',
                    style: TextStyle(
                      color: Colors.blue[700],
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

  Widget _buildTypingIndicator() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, chatState) {
        // Determine if this is for voice or text
        final isVoiceMessage = chatState.recordedAudioPath != null;
        final typingText = isVoiceMessage ? 'AI is transcribing...' : 'AI is typing...';
        
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
                  child:_buildTypingDots(),
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
    
    if (difference.inDays > 0) {
      return '${dateTime.day} ${_getMonthName(dateTime.month)}, ${dateTime.year}';
    } else {
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  Future<void> _playVoiceMessage(String audioPath) async {
    try {
      if (File(audioPath).existsSync()) {
        await _audioPlayer.setFilePath(audioPath);
        await _audioPlayer.play();
      }
    } catch (e) {
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

  /// Play text-to-speech audio
  Future<void> _playTextToSpeech(ChatMessage message) async {
    try {
      print('🎵 Playing text-to-speech for: ${message.message}'); // Debug log
      
      // Show loading state
      setState(() {
        message.isPlaying= true;
        _isPlayingPreview = true;
      });
      
      // Call the cubit to synthesize text to speech
      final audioBytes = await context.read<ChatCubit>().synthesizeTextToSpeech(message.message);
      
      if (audioBytes.isNotEmpty) {
        // Convert base64 audio bytes to temporary file and play
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.ogg');
        
        // Write base64 decoded audio bytes to temporary file
        await tempFile.writeAsBytes(base64Decode(audioBytes));
        
        // Play the temporary audio file
        await _audioPlayer.setFilePath(tempFile.path);
        await _audioPlayer.play();
        
        print('🎵 Text-to-speech playback started'); // Debug log
        
        // Clean up temporary file after playback
        _audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            message.isPlaying= false;
            tempFile.delete();
          }
        });
      } else {
        throw Exception('No audio data received');
      }
    } catch (e) {
      print('🎵 Text-to-speech playback error: $e'); // Debug log
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to play text-to-speech: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      // Reset playing state
      setState(() {
        message.isPlaying= false;
        _isPlayingPreview = false;
      });
    }
  }

  Future<void> _playRecordedAudio(String audioPath) async {
    try {
      print('Playing audio from: $audioPath'); // Debug log
      
      // Check if file exists
      final file = File(audioPath);
      if (!await file.exists()) {
        throw Exception('Audio file not found at: $audioPath');
      }
      
      print('File exists, setting audio source'); // Debug log
      
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
      
      print('Audio started playing'); // Debug log
    } catch (e) {
      print('Error playing audio: $e'); // Debug log
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
      print('Pausing audio'); // Debug log
      await _audioPlayer.pause();
      
      setState(() {
        _isPlayingPreview = false;
      });
      
      print('Audio paused'); // Debug log
    } catch (e) {
      print('Error pausing audio: $e'); // Debug log
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