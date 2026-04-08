
import "./MyPage.css";
const PROFILE_IMG = "";

export default function MyPage({ name = "Bruce Wayne", id = "12345", progress = 0 }) {
  return (
    <div className="mypage-shell">

      <div className="mypage-body">
        <div className="mypage-left">
          <div className="profile-block">
            <div className="avatar">
              <img src={PROFILE_IMG} alt="profile" />
            </div>

            <div className="profile-meta">
              <div className="profile-name">{name}</div>
              <div className="profile-id">ID: {id}</div>
            </div>

            <button className="settings-btn" title="Settings">⚙️</button>
          </div>

          <div className="progress-section">
            <div className="progress-label">Goal Progress</div>
            <div className="progress-bar-wrap" aria-hidden>
              <div className="progress-bar-bg">
                <div className="progress-bar-fill" style={{ width: `${progress}%` }} />
              </div>
              <div className="progress-numeric">{progress} / 100</div>
            </div>
          </div>
        </div>

        <div className="mypage-right"></div>
      </div>
    </div>
  );
}
