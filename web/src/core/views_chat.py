from rest_framework import viewsets, status, serializers
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import ChatConversation, ChatMessage
from .serializers import (
    ChatConversationSerializer,
    ChatConversationWriteSerializer,
    ChatMessageSerializer,
)
from django.contrib.auth import get_user_model
from .models import Supplier, SupplierStaff

User = get_user_model()

def get_user_supplier(user):
    """Helper function to get supplier from user (owner or staff)"""
    if user.role == 'supplier':
        try:
            return user.supplier_profile
        except:
            try:
                staff = user.staff_profile
                return staff.supplier if staff else None
            except:
                return None
    return None


class ChatConversationViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing chat conversations.
    """
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        supplier = get_user_supplier(self.request.user)
        if supplier:
            return ChatConversation.objects.filter(supplier=supplier).prefetch_related('messages')
        return ChatConversation.objects.none()

    def get_serializer_class(self):
        if self.action == 'create' or self.action == 'update' or self.action == 'partial_update':
            return ChatConversationWriteSerializer
        return ChatConversationSerializer

    def perform_create(self, serializer):
        supplier = get_user_supplier(self.request.user)
        if not supplier:
            raise PermissionError('Supplier profile not found')
        serializer.save(supplier=supplier)


class ChatMessageViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing chat messages.
    """
    serializer_class = ChatMessageSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        supplier = get_user_supplier(self.request.user)
        conversation_id = self.request.query_params.get('conversation')
        
        if supplier:
            conversations = ChatConversation.objects.filter(supplier=supplier)
            queryset = ChatMessage.objects.filter(conversation__in=conversations)
            if conversation_id:
                queryset = queryset.filter(conversation_id=conversation_id)
            return queryset.order_by('created_at')
        return ChatMessage.objects.none()

    def perform_create(self, serializer):
        conversation_id = self.request.data.get('conversation')
        if not conversation_id:
            raise serializers.ValidationError({'conversation': 'Conversation ID is required'})
        
        supplier = get_user_supplier(self.request.user)
        try:
            conversation = ChatConversation.objects.get(id=conversation_id, supplier=supplier)
        except ChatConversation.DoesNotExist:
            raise PermissionError('Conversation not found or access denied')
        
        serializer.save(conversation=conversation, user=self.request.user)

