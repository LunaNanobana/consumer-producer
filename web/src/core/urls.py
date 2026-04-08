from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    SupplierViewSet,
    SupplierStaffViewSet,
    ProductViewSet,
    ProductCategoryViewSet,
    OrderViewSet,
    ComplaintViewSet,
    ChatConversationViewSet,
    ChatMessageViewSet,
)

router = DefaultRouter()
router.register(r'suppliers', SupplierViewSet, basename='supplier')
router.register(r'staff', SupplierStaffViewSet, basename='staff')
router.register(r'products', ProductViewSet, basename='product')
router.register(r'categories', ProductCategoryViewSet, basename='category')
router.register(r'orders', OrderViewSet, basename='order')
router.register(r'complaints', ComplaintViewSet, basename='complaint')
router.register(r'chat/conversations', ChatConversationViewSet, basename='chat-conversation')
router.register(r'chat/messages', ChatMessageViewSet, basename='chat-message')

urlpatterns = [
    path('', include(router.urls)),
]

