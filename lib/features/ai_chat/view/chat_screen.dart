import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/result.dart';
import '../../../data/ui_state/status.dart';
import '../../../dependency_injection/locator.dart';
import '../../../service/location_service.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/toast_messages.dart';
import '../../profile/cubit/profile/profile_cubit.dart';
import '../../vehicle_provider/vp_all_loads/view/vp_all_loads_screen.dart';
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
  final LocationService _locationService = LocationService();
  String? _currentLocation; // Store current city and state
  String? _loadingTTSMessageId; // Track which message is loading TTS

  // Scroll position tracking - simplified
  // Simple scroll tracking like your working example
  bool _isAtBottom = true;
  int _lastMessageCount = 0;

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
      // Get current city when screen loads
      _getCurrentCity();
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
      // With reverse: true, "bottom" is actually position 0
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Handle scroll events - exactly like your working example
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    // Simple bottom detection like your example
    _isAtBottom = _scrollController.position.pixels <= 50;

    // Simple pagination trigger - exactly like your working example
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final chatCubit = context.read<ChatCubit>();

      if (chatCubit.state.hasMoreMessages && !_isLoadingHistory) {
        _isLoadingHistory = true;
        chatCubit.loadMoreChatHistory().whenComplete(() {
          _isLoadingHistory = false;
        });
      }
    }
  }

  /// Get current full address from user's location
  Future<void> _getCurrentCity() async {
    try {
      final positionResult = await _locationService.getCurrentLatLong();

      if (positionResult is Success) {
        final successResult = positionResult as Success;
        final position = successResult.value;

        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );

          if (placemarks.isNotEmpty) {
            final placemark = placemarks.first;

            // Build full address in the format: Area, Subarea, City, State Pincode
            List<String> addressParts = [];
            if (placemark.subThoroughfare != null &&
                placemark.subThoroughfare!.isNotEmpty) {
              addressParts.add(placemark.subThoroughfare!);
            }
            if (placemark.thoroughfare != null &&
                placemark.thoroughfare!.isNotEmpty) {
              addressParts.add(placemark.thoroughfare!);
            }
            if (placemark.subLocality != null &&
                placemark.subLocality!.isNotEmpty) {
              addressParts.add(placemark.subLocality!);
            }
            if (placemark.locality != null && placemark.locality!.isNotEmpty) {
              addressParts.add(placemark.locality!);
            }
            if (placemark.administrativeArea != null &&
                placemark.administrativeArea!.isNotEmpty) {
              addressParts.add(placemark.administrativeArea!);
            }
            if (placemark.postalCode != null &&
                placemark.postalCode!.isNotEmpty) {
              addressParts.add(placemark.postalCode!);
            }

            // Create full address string
            if (addressParts.isNotEmpty) {
              _currentLocation = addressParts.join(', ');
            } else {
              _currentLocation = 'unknown';
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('🌍 ChatScreen: Error getting location details: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('🌍 ChatScreen: Error getting current address: $e');
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
                  backgroundColor: const Color(0xFFE31B25), // Red background
                ),
              );
              context.read<ChatCubit>().clearError();
            }

            // Show success message toast
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.successMessage!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
              context.read<ChatCubit>().clearSuccessMessage();
            }

            // Simple auto-scroll logic - only for new messages when user is at bottom
            if (_isAtBottom &&
                state.messages.length > _lastMessageCount &&
                !_isLoadingHistory) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });
            }

            // Initial scroll on first load
            if (state.isInitialLoadingComplete &&
                _lastMessageCount == 0 &&
                state.messages.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });
            }

            // Track message count
            _lastMessageCount = state.messages.length;
          },
          builder: (context, state) {
            return Column(
              children: [
                // Messages List
                Expanded(child: _buildMessagesList(state.messages)),
                // Recording Indicator or Audio Preview
                if (state.isRecording) _buildRecordingIndicator(state),
                if (state.recordedAudioPath != null) _buildAudioPreview(state),
                // Input area (text input or audio preview)
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
        'Gro AI Saathi',
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

  Widget _buildDisclaimerBanner() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.grayColor, size: 18),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              'Gro AI Saathi can make mistakes, so double-check it',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.grayColor,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatLimit() {
    return BlocListener<ChatCubit, ChatState>(
      listenWhen: (previous, current) {
        final changed =
            previous.todaysChatCount != current.todaysChatCount ||
            previous.dailyChatLimit != current.dailyChatLimit;
        if (changed) {}
        return changed;
      },
      listener: (context, state) {},
      child: BlocBuilder<ChatCubit, ChatState>(
        buildWhen: (previous, current) {
          final shouldRebuild =
              previous.todaysChatCount != current.todaysChatCount ||
              previous.dailyChatLimit != current.dailyChatLimit;
          return shouldRebuild;
        },
        builder: (context, state) {
          // Show 0/0 initially until data is loaded from API
          final todaysCount = state.todaysChatCount;
          final dailyLimit = state.dailyChatLimit;
          return Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Chats Today : ',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                        TextSpan(
                          text: '$todaysCount',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        TextSpan(
                          text: ' / $dailyLimit',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.grayColor,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
                    reported: false, // Default greeting is not reported
                  ),
                ]
                : messages.reversed.toList();

        return ListView.builder(
          reverse:
              true, // Important for chat-like behavior - like working example
          key: const PageStorageKey('chat-list'),
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount:
              displayMessages.length +
              (state.isTyping ? 1 : 0) +
              (state.hasMoreMessages ? 1 : 0) +
              (state.isProcessingVoice ? 2 : 0),
          itemBuilder: (context, index) {
            // With reverse: true, indicators should appear at the top (index 0)
            int currentIndex = 0;

            // Voice processing indicators (appear first at top)
            if (state.isProcessingVoice) {
              if (index == currentIndex) {
                // Show "AI is thinking..." message (AI side) - appears first at top
                return _buildTypingIndicator();
              }
              currentIndex++;

              if (index == currentIndex) {
                // Show "Transcribing..." message (user side) - appears second
                return _buildTranscribingMessage();
              }
              currentIndex++;
            }

            // Typing indicator (for text messages)
            if (state.isTyping && !state.isProcessingVoice) {
              if (index == currentIndex) {
                return _buildTypingIndicator();
              }
              currentIndex++;
            }

            // Messages
            final messageIndex = index - currentIndex;
            if (messageIndex >= 0 && messageIndex < displayMessages.length) {
              return _buildMessageBubble(displayMessages[messageIndex]);
            }

            // Loading indicator at bottom (when loading more history)
            if (state.hasMoreMessages &&
                index == displayMessages.length + currentIndex) {
              return _buildTopLoadingIndicator();
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

          isUser
              ? IntrinsicWidth(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(
                      16,
                    ).copyWith(bottomRight: const Radius.circular(4)),
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
                      GestureDetector(
                        onLongPress: () => _showMessageOptions(message),
                        child: RichText(
                          text: _buildTextSpanWithLinksForUser(message.message),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(fontSize: 12, color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              )
              : Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      16,
                    ).copyWith(bottomLeft: const Radius.circular(4)),
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
                        _buildRichTextMessage(message.message, message),

                      // Add "View Loads" button when message contains load-related content
                      if (!isVoice &&
                          _isLoadRelatedMessage(message.message)) ...[
                        const SizedBox(height: 8),
                        _buildViewLoadsButton(
                          _createLoadDataFromMessage(message.message),
                        ),
                      ],

                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side: timestamp, language, and report icon
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatTime(message.timestamp),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grayColor,
                                ),
                              ),
                              if (!isVoice) ...[
                                const SizedBox(width: 8),
                                // Language indicator
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.grayColor.withValues(
                                      alpha: 0.2,
                                    ),
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
                                // Report icon for AI text responses
                                if (!message.reported)
                                  GestureDetector(
                                    onTap: () {
                                      // Show confirmation dialog before reporting
                                      _showReportConfirmationDialog(message.id);
                                    },
                                    child: Icon(
                                      Icons.thumb_down_off_alt_outlined,
                                      size: 16,
                                      color: AppColors.grayColor,
                                    ),
                                  )
                                else
                                  // Show "Reported" label when message is already reported
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFE31B25,
                                      ).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.thumb_down_off_alt_outlined,
                                      size: 16,
                                      color: AppColors.red,
                                    ),
                                  ),
                              ],
                            ],
                          ),
                          // Right side: speaker icon positioned on far right of the card
                          if (!isVoice)
                            GestureDetector(
                              onTap: () {
                                // Don't allow tap if this message is loading TTS
                                if (_loadingTTSMessageId == message.id) return;

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
                              child:
                                  _loadingTTSMessageId == message.id
                                      ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.primaryColor,
                                              ),
                                        ),
                                      )
                                      : Icon(
                                        message.isPlaying
                                            ? Icons.stop
                                            : Icons.volume_up,
                                        size: 20,
                                        color:
                                            message.isPlaying
                                                ? const Color(0xFFE31B25)
                                                : AppColors.grayColor,
                                      ),
                            ),
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
        color: const Color(0xFFFFEBEE), // Light red background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEF5350)), // Red border
      ),
      child: Row(
        children: [
          // Animated recording indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFFE31B25), // Red circle
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
                    color: Color(0xFFE31B25), // Red text
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.recordingDuration}s / 15s${state.recordingDuration >= 12 ? ' (stopping soon)' : ''}',
                  style: TextStyle(
                    color:
                        state.recordingDuration >= 12
                            ? const Color(0xFFB71C1C) // Dark red
                            : const Color(0xFFD32F2F), // Medium red
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
                  backgroundColor: const Color(
                    0xFFFFCDD2,
                  ), // Light red background
                  valueColor: AlwaysStoppedAnimation<Color>(
                    state.recordingDuration >= 12
                        ? const Color(0xFFB71C1C) // Dark red
                        : const Color(0xFFE31B25), // Red
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
                icon: const Icon(
                  Icons.delete,
                  color: Color(0xFFE31B25),
                ), // Red delete icon
                style: IconButton.styleFrom(
                  backgroundColor: const Color(
                    0xFFFFCDD2,
                  ), // Light red background
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
                              context.read<ChatCubit>().sendRecordedAudio(
                                currentLocation: _currentLocation,
                              );
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
      child: Column(
        children: [
          _buildChatLimit(),
          Row(
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
                            minLines: 1,
                            maxLines: 3,
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
                                color:
                                    isDisabled ? Colors.grey[400] : Colors.grey,
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
                                ? const Color(0xFFE31B25) // Red when recording
                                : state.recordedAudioPath != null
                                ? Colors.blue[300]
                                : canRecord
                                ? Colors.grey[400]
                                : Colors
                                    .grey[300], // Lighter grey when disabled
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
                                  context.read<ChatCubit>().sendTextMessage(
                                    text,
                                    currentLocation: _currentLocation,
                                  );
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
                          isWaitingForResponse
                              ? Icons.hourglass_empty
                              : Icons.send,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          // Disclaimer Banner
          _buildDisclaimerBanner(),
        ],
      ),
    );
  }

  /// Build floating language options (horizontal layout)
  Widget _buildFloatingLanguageOptions() {
    return Container(
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
      // Set loading state for this specific message
      setState(() {
        _loadingTTSMessageId = message.id;
      });

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

      // Clear loading state
      setState(() {
        _loadingTTSMessageId = null;
      });

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
      // Clear loading state on error
      setState(() {
        _loadingTTSMessageId = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to play text-to-speech: $e'),
            backgroundColor: const Color(0xFFE31B25), // Red background
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
            backgroundColor: const Color(0xFFE31B25), // Red background
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
            backgroundColor: const Color(0xFFE31B25), // Red background
          ),
        );
      }
    }
  }

  /// Show confirmation dialog before reporting a message
  void _showReportConfirmationDialog(String messageId) {
    // Capture the ChatCubit instance before showing the dialog
    final chatCubit = context.read<ChatCubit>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _ReportFeedbackDialog(
          messageId: messageId,
          onReport: (feedbackType) {
            // Call the cubit to report the message with feedback
            chatCubit.reportMessage(messageId, feedbackType: feedbackType);
          },
        );
      },
    );
  }

  /// Build rich text with clickable links and copy functionality
  Widget _buildRichTextMessage(String text, ChatMessage message) {
    return GestureDetector(
      onLongPress: () => _showMessageOptions(message),
      child: RichText(text: _buildTextSpanWithLinks(text)),
    );
  }

  /// Build TextSpan with clickable links for user messages (white text)
  TextSpan _buildTextSpanWithLinksForUser(String text) {
    final urlPattern = RegExp(
      r'https?://[^\s<>"{}|\\^`\[\]]+',
      caseSensitive: false,
    );

    final matches = urlPattern.allMatches(text);
    if (matches.isEmpty) {
      return TextSpan(
        text: text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      );
    }

    List<TextSpan> spans = [];
    int lastIndex = 0;

    for (final match in matches) {
      // Add text before the URL
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        );
      }

      // Add the clickable URL
      final url = match.group(0)!;
      spans.add(
        TextSpan(
          text: url,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
          recognizer: TapGestureRecognizer()..onTap = () => _launchUrl(url),
        ),
      );

      lastIndex = match.end;
    }

    // Add remaining text after the last URL
    if (lastIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      );
    }

    return TextSpan(children: spans);
  }

  /// Build TextSpan with clickable links for AI messages (black text)
  TextSpan _buildTextSpanWithLinks(String text) {
    final urlPattern = RegExp(
      r'https?://[^\s<>"{}|\\^`\[\]]+',
      caseSensitive: false,
    );

    final matches = urlPattern.allMatches(text);
    if (matches.isEmpty) {
      return TextSpan(
        text: text,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      );
    }

    List<TextSpan> spans = [];
    int lastIndex = 0;

    for (final match in matches) {
      // Add text before the URL
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        );
      }

      // Add the clickable URL
      final url = match.group(0)!;
      spans.add(
        TextSpan(
          text: url,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primaryColor,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.primaryColor,
          ),
          recognizer: TapGestureRecognizer()..onTap = () => _launchUrl(url),
        ),
      );

      lastIndex = match.end;
    }

    // Add remaining text after the last URL
    if (lastIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      );
    }

    return TextSpan(children: spans);
  }

  /// Launch URL in browser
  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not launch URL: $url');
      }
    } catch (e) {
      _showErrorSnackBar('Error launching URL: $e');
    }
  }

  /// Show message options (copy, etc.)
  void _showMessageOptions(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.copy, color: AppColors.primaryColor),
                  title: const Text('Copy Text'),
                  onTap: () {
                    _copyToClipboard(message.message);
                    Navigator.pop(context);
                  },
                ),
                if (!message.isUser &&
                    message.messageType != MessageType.voice) ...[
                  ListTile(
                    leading:
                        _loadingTTSMessageId == message.id
                            ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor,
                                ),
                              ),
                            )
                            : Icon(
                              Icons.volume_up,
                              color: AppColors.primaryColor,
                            ),
                    title: const Text('Play Audio'),
                    onTap:
                        _loadingTTSMessageId == message.id
                            ? null // Disable tap when loading
                            : () {
                              Navigator.pop(context);
                              _playTextToSpeech(message);
                            },
                  ),
                  if (!message.reported)
                    ListTile(
                      leading: Icon(
                        Icons.thumb_down_off_alt_outlined,
                        color: AppColors.grayColor,
                      ),
                      title: const Text('Report Message'),
                      onTap: () {
                        Navigator.pop(context);
                        _showReportConfirmationDialog(message.id);
                      },
                    ),
                ],
              ],
            ),
          ),
    );
  }

  /// Copy text to clipboard
  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    _showSuccessSnackBar('Text copied to clipboard');
  }

  /// Show success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Build "View Loads" button for messages with load data
  Widget _buildViewLoadsButton(LoadData loadData) {
    return GestureDetector(
      onTap: () => _navigateToVpAllLoads(loadData),
      child: Row(
        children: [
          Text(
            'View Loads',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.visibility,
              size: 16,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
    // return Container(
    //   child: ElevatedButton.icon(
    //     onPressed: () => _navigateToVpAllLoads(loadData),
    //     icon: Icon(Icons.visibility, size: 16, color: Colors.white),
    //     label: Text(
    //       'View Loads',
    //       style: TextStyle(
    //         color: Colors.white,
    //         fontSize: 14,
    //         fontWeight: FontWeight.w600,
    //       ),
    //     ),
    //   ),
    // );
  }

  /// Check if the message content is about loads list available
  bool _isLoadRelatedMessage(String message) {
    final lowerMessage = message.toLowerCase();

    // Check for specific pattern that indicates loads list available
    final loadsListPatterns = [
      'loads available on the',
      'loads available',
      'available loads',
      'here are the loads available',
      'based on the provided context, here are the loads available',
      'loads list available',
      'available loads list',
    ];

    // Check if message contains the specific pattern for loads list
    return loadsListPatterns.any((pattern) => lowerMessage.contains(pattern));
  }

  /// Extract load data from message content
  LoadData _createLoadDataFromMessage(String message) {
    String? source;
    String? destination;
    int? routeId;

    // First try to extract from the specific pattern: "loads available on the X to Y lane"
    final loadsAvailablePattern = RegExp(
      r'loads available on the\s+([^,\n]+?)\s+to\s+([^,\n]+?)(?:\s+\(or\s+[^)]+\))?\s+lane',
      caseSensitive: false,
    );
    final loadsMatch = loadsAvailablePattern.firstMatch(message);

    if (loadsMatch != null) {
      source = loadsMatch.group(1)?.trim();
      destination = loadsMatch.group(2)?.trim();

      // Clean up destination - remove "(or Bengaluru)" type text
      if (destination != null) {
        destination =
            destination
                .replaceAll(
                  RegExp(r'\s*\(or\s+[^)]+\)', caseSensitive: false),
                  '',
                )
                .trim();
      }
    } else {
      // Fallback to general patterns
      final fromToPattern = RegExp(
        r'from\s+([^,\n]+?)\s+to\s+([^,\n]+)',
        caseSensitive: false,
      );
      final toPattern = RegExp(
        r'([^,\n]+?)\s+to\s+([^,\n]+)',
        caseSensitive: false,
      );

      final fromToMatch = fromToPattern.firstMatch(message);
      if (fromToMatch != null) {
        source = fromToMatch.group(1)?.trim();
        destination = fromToMatch.group(2)?.trim();
      } else {
        final toMatch = toPattern.firstMatch(message);
        if (toMatch != null) {
          source = toMatch.group(1)?.trim();
          destination = toMatch.group(2)?.trim();
        }
      }
    }

    // Try to extract route ID from the message
    // Look for patterns like "Route ID: 123", "route id: 123", "ID: 123", etc.
    final routeIdPatterns = [
      RegExp(r'route\s+id\s*:?\s*(\d+)', caseSensitive: false),
      RegExp(r'id\s*:?\s*(\d+)', caseSensitive: false),
      RegExp(r'route\s*:?\s*(\d+)', caseSensitive: false),
      RegExp(r'lane\s+id\s*:?\s*(\d+)', caseSensitive: false),
    ];

    for (final pattern in routeIdPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        routeId = int.tryParse(match.group(1) ?? '');
        if (routeId != null) {
          break;
        }
      }
    }

    return LoadData(
      source: source,
      destination: destination,
      commodity: null,
      truckType: null,
      routeId: routeId,
    );
  }

  /// Navigate to VpAllLoadsScreen with filter parameters from load data
  void _navigateToVpAllLoads(LoadData loadData) {
    // Navigate to VpAllLoadsScreen with filter parameters
    // We'll use the existing navigation pattern from the app
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => VpAllLoadsScreen(
              initialTabIndex: 0, // Start with "Available Loads" tab
              filterData:
                  loadData, // Pass the extracted load data for filtering
            ),
      ),
    );
  }
}

class _ReportFeedbackDialog extends StatefulWidget {
  final String messageId;
  final Function(String feedbackType) onReport;

  const _ReportFeedbackDialog({
    required this.messageId,
    required this.onReport,
  });

  @override
  State<_ReportFeedbackDialog> createState() => _ReportFeedbackDialogState();
}

class _ReportFeedbackDialogState extends State<_ReportFeedbackDialog> {
  String? _selectedFeedbackType;
  final TextEditingController _additionalFeedbackController =
      TextEditingController();

  final List<String> _feedbackOptions = [
    'Not factually correct',
    'Didn\'t follow instructions',
    'Offensive/Unsafe',
    'Wrong language',
    'Poorly formatted',
    'Generic/Bland',
    'Other',
  ];

  @override
  void dispose() {
    _additionalFeedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'What went wrong?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your feedback helps make Gro AI Saathi better for everyone.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 24),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Feedback Options
              ...(_feedbackOptions.map(
                (option) => _buildFeedbackOption(option),
              )),

              // Additional feedback input for "Other" option
              if (_selectedFeedbackType == 'Other') ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please specify what went wrong:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _additionalFeedbackController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter your feedback here...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _selectedFeedbackType != null
                          ? () {
                            String feedbackType = _selectedFeedbackType!;

                            // If "Other" is selected, combine with additional feedback if available
                            if (feedbackType == 'Other') {
                              final additionalText =
                                  _additionalFeedbackController.text.trim();
                              feedbackType =
                                  additionalText.isNotEmpty
                                      ? 'other-$additionalText'
                                      : 'other';
                            }

                            widget.onReport(feedbackType);
                            Navigator.of(context).pop();
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackOption(String option) {
    final isSelected = _selectedFeedbackType == option;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFeedbackType = option;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppColors.primaryColor.withValues(alpha: 0.1)
                    : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color:
                        isSelected
                            ? AppColors.primaryColor
                            : const Color(0xFF1F1F1F),
                  ),
                ),
              ),
              if (isSelected)
                AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.check,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
