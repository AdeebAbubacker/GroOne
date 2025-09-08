import 'package:equatable/equatable.dart';
import '../model/chat_message.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final ChatLanguage selectedLanguage;
  final bool isLoading;
  final bool isRecording;
  final bool isTyping; // AI is typing response
  final bool isProcessingVoice; // Voice message is being transcribed
  final bool hasMoreMessages; // Whether there are more messages to load
  final bool isInitialLoadingComplete; // Whether initial chat history loading is complete
  final String? recordedAudioPath;
  final int recordingDuration;
  final String? error;
  final String? successMessage; // Success message for toasts
  final int pageNo;
  // Chat limit tracking
  final int todaysChatCount; // Current number of chats used today
  final int dailyChatLimit; // Maximum chats allowed per day

  const ChatState({
    this.messages = const [],
    this.selectedLanguage = ChatLanguage.english,
    this.isLoading = false,
    this.isRecording = false,
    this.isTyping = false,
    this.isProcessingVoice = false,
    this.hasMoreMessages = true,
    this.isInitialLoadingComplete = false,
    this.recordedAudioPath,
    this.recordingDuration = 0,
    this.pageNo =1,
    this.error,
    this.successMessage,
    this.todaysChatCount = 0,
    this.dailyChatLimit = 0,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    ChatLanguage? selectedLanguage,
    bool? isLoading,
    bool? isRecording,
    bool? isTyping,
    bool? isProcessingVoice,
    bool? hasMoreMessages,
    bool? isInitialLoadingComplete,
    String? recordedAudioPath,
    bool clearRecordedAudioPath = false,
    int? recordingDuration,
    int? pageNo = 1,
    String? error,
    bool clearError = false,
    String? successMessage,
    bool clearSuccessMessage = false,
    int? todaysChatCount,
    int? dailyChatLimit,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isLoading: isLoading ?? this.isLoading,
      isRecording: isRecording ?? this.isRecording,
      isTyping: isTyping ?? this.isTyping,
      isProcessingVoice: isProcessingVoice ?? this.isProcessingVoice,
      isInitialLoadingComplete: isInitialLoadingComplete ?? this.isInitialLoadingComplete,
      pageNo: pageNo ?? this.pageNo,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      recordedAudioPath: clearRecordedAudioPath ? null : (recordedAudioPath ?? this.recordedAudioPath),
      recordingDuration: recordingDuration ?? this.recordingDuration,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      todaysChatCount: todaysChatCount ?? this.todaysChatCount,
      dailyChatLimit: dailyChatLimit ?? this.dailyChatLimit,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        selectedLanguage,
        isLoading,
        isRecording,
        isTyping,
        isProcessingVoice,
        hasMoreMessages,
        isInitialLoadingComplete,
        recordedAudioPath,
        recordingDuration,
        error,
        successMessage,
        todaysChatCount,
        dailyChatLimit,
      ];
}
