.product-list-vertical {
  display: block;
  width: 100%;
  box-sizing: border-box;
}

.product-list-vertical > * {
  display: block;
  width: 100%;
  margin-bottom: 18px;
  box-sizing: border-box;
}

.product-card-vertical {
  display: flex !important;
  flex-direction: row !important;
  align-items: center !important;
  width: 100% !important;
  padding: 0 !important;
  border-radius: 14px !important;
  overflow: hidden !important;
  min-height: 140px !important;
  box-sizing: border-box !important;
}

.product-card-vertical .product-thumb-vertical {
  flex: 0 0 140px !important;
  width: 140px !important;
  height: 140px !important;
  min-width: 140px !important;
  min-height: 140px !important;
  max-width: 140px !important;
  max-height: 140px !important;
  overflow: hidden !important;
  display: block !important;
  box-sizing: border-box !important;
  margin: 0 !important;
  background: #fff !important;
  pointer-events: none !important;
}

.product-card-vertical .product-thumb-vertical img{
  width: 100% !important;
  height: 100% !important;
  max-width: 100% !important;
  max-height: 100% !important;
  object-fit: cover !important;
  display: block !important;
  user-select: none !important;
  -webkit-user-drag: none !important;
  pointer-events: none !important;
}

.product-card-vertical .product-info-vertical {
  flex: 1 1 auto !important;
  padding: 16px 20px !important;
  box-sizing: border-box !important;
  min-width: 0 !important;
}

.product-card-vertical .product-actions-vertical {
  flex: 0 0 auto !important;
  padding: 16px 24px !important;
  box-sizing: border-box !important;
}

.product-card-vertical:hover { transform: translateY(-2px) !important; }

@media (max-width: 600px) {
  .product-card-vertical .product-thumb-vertical {
    flex: 0 0 100px !important;
    width: 100px !important;
    height: 100px !important;
    min-width: 100px !important;
    min-height: 100px !important;
    max-width: 100px !important;
    max-height: 100px !important;
  }
  .product-card-vertical { min-height: 100px !important; }
}
