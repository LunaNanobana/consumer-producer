import React, { useState } from "react";
import "./Catalog.css";

const initialCatalog = [
  { id: "001", name: "Apples", amount: "120 kg", image: "https://www.aussieapples.com.au/wp-content/uploads/2017/06/pink-lady-300x300.png" },
  { id: "002", name: "Olive Oil", amount: "50 l", image: "https://earth-ona.com/wp-content/uploads/2024/01/Olive-oil-300x300.jpg" },
  { id: "003", name: "Tomatoes", amount: "80.5 kg", image: "https://www.sunsetgrown.com/wp-content/uploads/2020/10/carousel-beefsteak-tomato-300x300.png" },
  { id: "004", name: "Milk", amount: "200 l", image: "https://marisamoore.com/wp-content/uploads/2021/06/Homemade-Hemp-Milk-recipe-300x300.jpg" }
];

function InfoModal({ item, onClose }) {
  if (!item) return null;
  return (
    <div className="catalog-modal-overlay">
      <div className="catalog-modal">
        <button className="modal-close" onClick={onClose}>✕</button>

        <h3 className="modal-title">Product info</h3>

        <div className="modal-body">
          <div className="modal-row"><strong>Name:</strong> {item.name}</div>
          <div className="modal-row"><strong>ID:</strong> {item.id}</div>
          <div className="modal-row"><strong>Amount:</strong> {item.amount}</div>
        </div>

        <div className="modal-actions">
          <button className="modal-btn" onClick={onClose}>Close</button>
        </div>
      </div>
    </div>
  );
}

export default function Catalog() {
  const [items] = useState(initialCatalog);
  const [infoItem, setInfoItem] = useState(null);

  return (
    <div className="catalog-shell">
      <div className="catalog-header">
        <h2>Catalog</h2>
        <div className="catalog-count">Total: {items.length}</div>
      </div>

      <div className="catalog-list">
        {items.map((it, idx) => (
          <div className="catalog-row" key={it.id}>
            <div className="catalog-index">{idx + 1}</div>

            <div className="catalog-thumb">
              <img src={it.image} alt={it.name} />
            </div>

            <div className="catalog-main">
              <div className="catalog-name">{it.name}</div>
              <div className="catalog-sub">ID: {it.id}</div>
            </div>

            <div className="catalog-actions">
              <button className="btn-info" onClick={() => setInfoItem(it)}>Info</button>
              <button className="btn-edit" onClick={() => alert("Edit clicked")}>Edit</button>
            </div>
          </div>
        ))}
      </div>

      {/* -------- Add Button (does nothing) -------- */}
      <div className="catalog-add-container">
        <button className="catalog-add-btn" type="button" onClick={() => {}}>
          <span className="plus">＋</span> Add
        </button>
      </div>

      <InfoModal item={infoItem} onClose={() => setInfoItem(null)} />
    </div>
  );
}
