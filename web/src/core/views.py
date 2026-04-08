from rest_framework import viewsets, status, serializers
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import get_user_model
from .models import Supplier, SupplierStaff, Product, ProductCategory, Order, Complaint, ChatConversation, ChatMessage
from .serializers import (
    UserSerializer,
    SupplierSerializer,
    SupplierStaffSerializer,
    SupplierStaffWriteSerializer,
    ProductSerializer,
    ProductWriteSerializer,
    ProductCategorySerializer,
    OrderSerializer,
    ComplaintSerializer,
    ComplaintWriteSerializer,
    ChatConversationSerializer,
    ChatConversationWriteSerializer,
    ChatMessageSerializer,
)

User = get_user_model()


def get_user_supplier(user):
    """Helper function to get supplier from user (owner or staff)"""
    if user.role == 'supplier':
        try:
            return Supplier.objects.get(user=user)
        except Supplier.DoesNotExist:
            return None
    elif hasattr(user, 'staff_profile'):
        return user.staff_profile.supplier
    return None


def get_user_staff_role(user):
    """Helper function to get staff role (owner, manager, sales)"""
    if user.role == 'supplier':
        try:
            staff = SupplierStaff.objects.get(user=user, supplier__user=user)
            return staff.role
        except SupplierStaff.DoesNotExist:
            return 'owner'
    elif hasattr(user, 'staff_profile'):
        return user.staff_profile.role
    return None


class SupplierViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing supplier information.
    Only suppliers can access their own data.
    """
    serializer_class = SupplierSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.role == 'supplier':
            return Supplier.objects.filter(user=user)
        elif user.role == 'admin':
            return Supplier.objects.all()
        return Supplier.objects.none()

    def get_serializer_class(self):
        if self.action == 'list' or self.action == 'retrieve':
            return SupplierSerializer
        return SupplierSerializer

    @action(detail=False, methods=['get'])
    def me(self, request):
        """Get current user's supplier profile"""
        supplier = get_user_supplier(request.user)
        

        if not supplier and request.user.role == 'supplier':
            try:
                from .models import Supplier, SupplierStaff
                staff = SupplierStaff.objects.filter(user=request.user).first()
                if staff:
                    supplier = staff.supplier
                else:
                    supplier_name = (request.user.first_name + " " + request.user.last_name).strip()
                    if not supplier_name or supplier_name.strip() == "":
                        supplier_name = request.user.username
                    
                    supplier = Supplier.objects.create(
                        user=request.user,
                        name=supplier_name,
                        legal_name=supplier_name,
                        contact_email=request.user.email or "",
                    )
                    SupplierStaff.objects.create(
                        supplier=supplier,
                        user=request.user,
                        role="owner"
                    )
            except Exception as e:
                import traceback
                error_msg = str(e)
                traceback.print_exc()
                return Response(
                    {'error': f'Supplier profile not found and could not be created: {error_msg}', 'created': False}, 
                    status=status.HTTP_200_OK
                )
        
        if not supplier:
            if request.user.role != 'supplier':
                return Response(
                    {'error': 'User is not a supplier'}, 
                    status=status.HTTP_403_FORBIDDEN
                )
            return Response(
                {'error': 'Supplier profile not found'}, 
                status=status.HTTP_200_OK
            )
            
        serializer = self.get_serializer(supplier)
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def deactivate(self, request, pk=None):
        """Deactivate a supplier account"""
        supplier = self.get_object()
        supplier.is_active = False
        supplier.user.is_active = False
        supplier.user.save()
        supplier.save()
        return Response({'status': 'Supplier deactivated'})

    @action(detail=True, methods=['delete'])
    def delete_account(self, request, pk=None):
        """Delete a supplier account"""
        supplier = self.get_object()
        supplier.user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class SupplierStaffViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing supplier staff (managers and salespeople).
    """
    serializer_class = SupplierStaffSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        supplier = get_user_supplier(self.request.user)
        if supplier:
            return SupplierStaff.objects.filter(supplier=supplier)
        return SupplierStaff.objects.none()

    @action(detail=False, methods=['get'])
    def my_role(self, request):
        """Get current user's staff role"""
        role = get_user_staff_role(request.user)
        supplier = get_user_supplier(request.user)
        return Response({
            'role': role or 'owner',
            'supplier_id': supplier.id if supplier else None
        })

    def get_serializer_class(self):
        if self.action == 'create':
            return SupplierStaffWriteSerializer
        return SupplierStaffSerializer

    def create(self, request, *args, **kwargs):
        """Create a new staff member account"""
        user = request.user
        staff_role = get_user_staff_role(user)
        if staff_role not in ['owner', 'manager']:
            return Response(
                {'error': 'Permission denied. Only owners and managers can add staff.'}, 
                status=status.HTTP_403_FORBIDDEN
            )
        
        supplier = get_user_supplier(user)
        if not supplier:
            return Response(
                {'error': 'Supplier profile not found'}, 
                status=status.HTTP_404_NOT_FOUND
            )
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        validated_data = serializer.validated_data
        username = validated_data.pop('username')
        email = validated_data.pop('email')
        password = validated_data.pop('password')
        first_name = validated_data.pop('first_name', '')
        last_name = validated_data.pop('last_name', '')
        new_staff_role = validated_data.pop('role', 'sales')
        new_user = User.objects.create_user(
            username=username,
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name,
            role='supplier'
        )
        staff = SupplierStaff.objects.create(
            supplier=supplier,
            user=new_user,
            role=new_staff_role
        )

        response_serializer = SupplierStaffSerializer(staff)
        return Response(response_serializer.data, status=status.HTTP_201_CREATED)

    @action(detail=True, methods=['post'])
    def deactivate(self, request, pk=None):
        """Deactivate a staff member account"""
        staff_role = get_user_staff_role(request.user)
        if staff_role != 'owner':
            return Response(
                {'error': 'Only owners can deactivate staff accounts'}, 
                status=status.HTTP_403_FORBIDDEN
            )
        staff = self.get_object()
        staff.user.is_active = False
        staff.user.save()
        return Response({'status': 'Staff member deactivated'})

    @action(detail=True, methods=['delete'])
    def delete_account(self, request, pk=None):
        """Delete a staff member account"""
        staff_role = get_user_staff_role(request.user)
        if staff_role != 'owner':
            return Response(
                {'error': 'Only owners can delete staff accounts'}, 
                status=status.HTTP_403_FORBIDDEN
            )
        staff = self.get_object()
        staff.user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class ProductViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing products.
    """
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        supplier = get_user_supplier(self.request.user)
        if supplier:
            return Product.objects.filter(supplier=supplier)
        return Product.objects.none()

    def get_serializer_class(self):
        if self.action == 'create' or self.action == 'update' or self.action == 'partial_update':
            return ProductWriteSerializer
        return ProductSerializer

    def create(self, request, *args, **kwargs):
        """Create product - only managers and owners"""
        supplier = get_user_supplier(request.user)
        staff_role = get_user_staff_role(request.user)
        if staff_role not in ['owner', 'manager']:
            return Response(
                {'error': 'Only managers and owners can add products'}, 
                status=status.HTTP_403_FORBIDDEN
            )
        
        if not supplier:
            return Response(
                {'error': 'Supplier profile not found'}, 
                status=status.HTTP_404_NOT_FOUND
            )
        
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save(supplier=supplier)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    def update(self, request, *args, **kwargs):
        """Update product - only managers and owners"""
        staff_role = get_user_staff_role(request.user)
        if staff_role not in ['owner', 'manager']:
            return Response(
                {'error': 'Only managers and owners can update products'}, 
                status=status.HTTP_403_FORBIDDEN
            )
        return super().update(request, *args, **kwargs)


class ProductCategoryViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing product categories.
    """
    serializer_class = ProductCategorySerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        supplier = get_user_supplier(self.request.user)
        if supplier:
            return ProductCategory.objects.filter(supplier=supplier)
        return ProductCategory.objects.none()

    def perform_create(self, serializer):
        supplier = get_user_supplier(self.request.user)
        if not supplier:
            raise PermissionError('Supplier profile not found')
        serializer.save(supplier=supplier)


class OrderViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for viewing orders.
    All staff can view orders.
    """
    serializer_class = OrderSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        supplier = get_user_supplier(self.request.user)
        if supplier:
            return Order.objects.filter(supplier=supplier)
        return Order.objects.none()

    @action(detail=True, methods=['post'])
    def mark_as_done(self, request, pk=None):
        """Mark order as completed - any authenticated user can do this"""
        order = self.get_object()
        order.status = 'completed'
        order.save()
        return Response({'status': 'Order marked as completed'})


class ComplaintViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing complaints.
    All staff can view and manage complaints.
    """
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        supplier = get_user_supplier(self.request.user)
        if supplier:
            orders = Order.objects.filter(supplier=supplier)
            return Complaint.objects.filter(order__in=orders)
        return Complaint.objects.none()

    def get_serializer_class(self):
        if self.action == 'create' or self.action == 'update' or self.action == 'partial_update':
            return ComplaintWriteSerializer
        return ComplaintSerializer

    @action(detail=True, methods=['post'])
    def forward_to_manager(self, request, pk=None):
        """Forward complaint to manager/owner"""
        complaint = self.get_object()
        complaint.status = 'in_progress'
        complaint.save()
        return Response({'status': 'Complaint forwarded to manager/owner'})

    @action(detail=True, methods=['post'])
    def resolve(self, request, pk=None):
        """Resolve complaint - any authenticated user can resolve"""
        complaint = self.get_object()
        complaint.status = 'resolved'
        from django.utils import timezone
        complaint.resolved_at = timezone.now()
        complaint.save()
        return Response({'status': 'Complaint resolved'})
from .views_chat import ChatConversationViewSet, ChatMessageViewSet
