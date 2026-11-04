const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const CHROME_PATH = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const OUT_DIR_IPHONE = path.join(__dirname, '../screenshots/iphone_6.1');
const OUT_DIR_IPAD = path.join(__dirname, '../screenshots/ipad_12.9');

fs.mkdirSync(OUT_DIR_IPHONE, { recursive: true });
fs.mkdirSync(OUT_DIR_IPAD, { recursive: true });

// SVG Hero Icons & Assets
const CATBOY_EMBLEM = `
<svg viewBox="0 0 100 100" class="hero-emblem-svg">
  <defs>
    <linearGradient id="catGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#00D4FF"/>
      <stop offset="50%" stop-color="#0052CC"/>
      <stop offset="100%" stop-color="#001845"/>
    </linearGradient>
  </defs>
  <path d="M50 10 L68 32 L88 24 L78 50 L86 74 L50 92 L14 74 L22 50 L12 24 L32 32 Z" fill="url(#catGrad)" stroke="#00F0FF" stroke-width="3"/>
  <polygon points="50,22 58,40 76,46 62,58 66,76 50,66 34,76 38,58 24,46 42,40" fill="#00F0FF" opacity="0.9"/>
  <circle cx="36" cy="48" r="4" fill="#FFFFFF"/>
  <circle cx="64" cy="48" r="4" fill="#FFFFFF"/>
</svg>`;

const OWLETTE_EMBLEM = `
<svg viewBox="0 0 100 100" class="hero-emblem-svg">
  <defs>
    <linearGradient id="owlGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#FF5D8F"/>
      <stop offset="50%" stop-color="#D90429"/>
      <stop offset="100%" stop-color="#590D22"/>
    </linearGradient>
  </defs>
  <path d="M50 15 C75 15 92 35 92 60 C92 78 75 90 50 90 C25 90 8 78 8 60 C8 35 25 15 50 15 Z" fill="url(#owlGrad)" stroke="#FF85A1" stroke-width="3"/>
  <path d="M12 45 Q50 30 88 45 Q50 65 12 45 Z" fill="#FF85A1" opacity="0.8"/>
  <circle cx="35" cy="50" r="14" fill="#FFF" stroke="#D90429" stroke-width="3"/>
  <circle cx="65" cy="50" r="14" fill="#FFF" stroke="#D90429" stroke-width="3"/>
  <circle cx="35" cy="50" r="7" fill="#800F2F"/>
  <circle cx="65" cy="50" r="7" fill="#800F2F"/>
  <polygon points="50,56 44,70 56,70" fill="#FFB703"/>
</svg>`;

const GEKKO_EMBLEM = `
<svg viewBox="0 0 100 100" class="hero-emblem-svg">
  <defs>
    <linearGradient id="gekkoGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#52B788"/>
      <stop offset="50%" stop-color="#2D6A4F"/>
      <stop offset="100%" stop-color="#081C15"/>
    </linearGradient>
  </defs>
  <path d="M50 10 C72 10 90 28 90 55 C90 78 72 90 50 90 C28 90 10 78 10 55 C10 28 28 10 50 10 Z" fill="url(#gekkoGrad)" stroke="#74C69D" stroke-width="3"/>
  <path d="M30 18 Q50 6 70 18 Q50 24 30 18 Z" fill="#74C69D"/>
  <circle cx="34" cy="46" r="12" fill="#FFF" stroke="#2D6A4F" stroke-width="3"/>
  <circle cx="66" cy="46" r="12" fill="#FFF" stroke="#2D6A4F" stroke-width="3"/>
  <ellipse cx="34" cy="46" rx="4" ry="9" fill="#1B4332"/>
  <ellipse cx="66" cy="46" rx="4" ry="9" fill="#1B4332"/>
  <path d="M36 72 Q50 82 64 72" stroke="#74C69D" stroke-width="4" fill="none" stroke-linecap="round"/>
</svg>`;

const CATBOY_AR_MASK_DETAILED = `
<svg viewBox="0 0 400 360" class="ar-mask-render">
  <defs>
    <linearGradient id="maskBlue" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#1E60CC"/>
      <stop offset="45%" stop-color="#003D99"/>
      <stop offset="100%" stop-color="#00184A"/>
    </linearGradient>
    <linearGradient id="earCyan" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#00FFFF"/>
      <stop offset="100%" stop-color="#0080FF"/>
    </linearGradient>
    <filter id="glowCyan" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur stdDeviation="8" result="blur" />
      <feComposite in="SourceGraphic" in2="blur" operator="over"/>
    </filter>
  </defs>

  <!-- Left Ear -->
  <polygon points="120,120 70,10 160,80" fill="url(#maskBlue)" stroke="#00D4FF" stroke-width="5" />
  <polygon points="115,110 82,30 148,82" fill="url(#earCyan)" opacity="0.8" />

  <!-- Right Ear -->
  <polygon points="280,120 330,10 240,80" fill="url(#maskBlue)" stroke="#00D4FF" stroke-width="5" />
  <polygon points="285,110 318,30 252,82" fill="url(#earCyan)" opacity="0.8" />

  <!-- Main Mask Body -->
  <path d="M90 130 C120 90 280 90 310 130 C335 170 330 240 290 280 C240 310 160 310 110 280 C70 240 65 170 90 130 Z"
        fill="url(#maskBlue)" stroke="#00E5FF" stroke-width="6" />

  <!-- Forehead Speed Stripes -->
  <path d="M200 95 L200 170 M175 110 L185 165 M225 110 L215 165"
        stroke="#00F0FF" stroke-width="6" stroke-linecap="round" filter="url(#glowCyan)"/>

  <!-- Left Wing Flare -->
  <path d="M95 190 Q60 210 105 240" stroke="#00F0FF" stroke-width="5" fill="none" stroke-linecap="round" />
  <!-- Right Wing Flare -->
  <path d="M305 190 Q340 210 295 240" stroke="#00F0FF" stroke-width="5" fill="none" stroke-linecap="round" />

  <!-- Eye Cutouts & Visor Glow -->
  <path d="M120 185 Q155 165 180 195 Q155 225 120 185 Z" fill="#00184A" stroke="#00F0FF" stroke-width="4"/>
  <ellipse cx="150" cy="195" rx="20" ry="12" fill="#00FFFF" filter="url(#glowCyan)"/>
  <circle cx="154" cy="193" r="5" fill="#FFFFFF"/>

  <path d="M280 185 Q245 165 220 195 Q245 225 280 185 Z" fill="#00184A" stroke="#00F0FF" stroke-width="4"/>
  <ellipse cx="250" cy="195" rx="20" ry="12" fill="#00FFFF" filter="url(#glowCyan)"/>
  <circle cx="254" cy="193" r="5" fill="#FFFFFF"/>

  <!-- Nose & Mouth Guard -->
  <polygon points="200,210 188,235 212,235" fill="#00E5FF"/>
  <path d="M175 265 Q200 280 225 265" stroke="#00F0FF" stroke-width="4" fill="none" stroke-linecap="round"/>
</svg>`;

function generateHtml({
  width,
  height,
  isTablet,
  badgeText,
  headline,
  subtitle,
  screenContentHtml
}) {
  const scaleRatio = isTablet ? 1.4 : 1.0;
  return `<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; user-select: none; }
  body {
    width: ${width}px;
    height: ${height}px;
    overflow: hidden;
    background: #020718;
    color: #ffffff;
    font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", "Montserrat", "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    display: flex;
    flex-direction: column;
    position: relative;
  }

  /* Starfield Background */
  .bg-stars {
    position: absolute;
    inset: 0;
    background:
      radial-gradient(circle at 50% 0%, #0d286d 0%, #041033 45%, #010617 100%);
    z-index: 1;
  }
  .bg-nebula {
    position: absolute;
    inset: 0;
    background-image:
      radial-gradient(2px 2px at 100px 150px, #00f0ff, rgba(0,0,0,0)),
      radial-gradient(2px 2px at 300px 80px, #ffffff, rgba(0,0,0,0)),
      radial-gradient(3px 3px at 550px 300px, #00d4ff, rgba(0,0,0,0)),
      radial-gradient(2px 2px at 800px 120px, #ffffff, rgba(0,0,0,0)),
      radial-gradient(2.5px 2.5px at 1050px 220px, #ffd166, rgba(0,0,0,0)),
      radial-gradient(2px 2px at 200px 600px, #ffffff, rgba(0,0,0,0)),
      radial-gradient(3px 3px at 900px 750px, #00f0ff, rgba(0,0,0,0)),
      radial-gradient(2px 2px at 450px 1100px, #ffffff, rgba(0,0,0,0)),
      radial-gradient(2px 2px at 750px 1400px, #00d4ff, rgba(0,0,0,0)),
      radial-gradient(3px 3px at 150px 1800px, #ffffff, rgba(0,0,0,0)),
      radial-gradient(2px 2px at 1000px 2100px, #00f0ff, rgba(0,0,0,0));
    background-repeat: repeat;
    opacity: 0.85;
    z-index: 2;
  }

  /* Rays from hero HQ */
  .hero-rays {
    position: absolute;
    top: -100px;
    left: 50%;
    transform: translateX(-50%);
    width: 1400px;
    height: 800px;
    background: radial-gradient(ellipse at center top, rgba(0, 162, 255, 0.25) 0%, rgba(0, 82, 204, 0.08) 50%, transparent 80%);
    pointer-events: none;
    z-index: 2;
  }

  /* Main Wrapper */
  .container {
    position: relative;
    z-index: 5;
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    padding: ${isTablet ? '70px 80px 60px' : '65px 45px 50px'};
  }

  /* Top App Store Banner Header */
  .header-banner {
    text-align: center;
    margin-bottom: ${isTablet ? '50px' : '36px'};
  }
  .badge-tag {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: ${isTablet ? '12px 30px' : '8px 20px'};
    background: rgba(0, 114, 255, 0.25);
    border: 2px solid #00D4FF;
    border-radius: 999px;
    font-size: ${isTablet ? '26px' : '19px'};
    font-weight: 800;
    letter-spacing: 2.5px;
    color: #00F0FF;
    text-transform: uppercase;
    box-shadow: 0 0 25px rgba(0, 212, 255, 0.4);
    margin-bottom: ${isTablet ? '20px' : '14px'};
  }
  .headline {
    font-size: ${isTablet ? '70px' : '52px'};
    font-weight: 900;
    line-height: 1.1;
    letter-spacing: -0.5px;
    text-transform: uppercase;
    background: linear-gradient(180deg, #FFFFFF 20%, #BFE5FF 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    filter: drop-shadow(0 4px 18px rgba(0, 162, 255, 0.5));
    margin-bottom: ${isTablet ? '16px' : '12px'};
  }
  .subtitle {
    font-size: ${isTablet ? '32px' : '23px'};
    font-weight: 500;
    color: #D1E4FF;
    line-height: 1.35;
    max-width: ${isTablet ? '1400px' : '900px'};
    margin: 0 auto;
    text-shadow: 0 2px 8px rgba(0,0,0,0.8);
  }

  /* Screen Device Card Mockup */
  .device-mockup-frame {
    flex: 1;
    background: #060e22;
    border-radius: ${isTablet ? '48px' : '44px'};
    border: ${isTablet ? '8px solid #1c3566' : '6px solid #1c3566'};
    box-shadow:
      0 0 0 2px #00d4ff,
      0 25px 70px rgba(0, 0, 0, 0.9),
      0 0 60px rgba(0, 114, 255, 0.35);
    overflow: hidden;
    display: flex;
    flex-direction: column;
    position: relative;
  }

  /* Status Bar */
  .status-bar {
    height: ${isTablet ? '46px' : '52px'};
    padding: 0 ${isTablet ? '36px' : '28px'};
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: ${isTablet ? '20px' : '18px'};
    font-weight: 700;
    color: #ffffff;
    z-index: 10;
  }
  .status-bar-icons {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: ${isTablet ? '18px' : '16px'};
  }

  /* App Screen View */
  .screen-view {
    flex: 1;
    display: flex;
    flex-direction: column;
    position: relative;
    padding: ${isTablet ? '28px 36px 36px' : '20px 24px 28px'};
    overflow: hidden;
  }

  /* Common UI Elements */
  .app-nav-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    z-index: 5;
  }
  .nav-btn {
    width: ${isTablet ? '64px' : '52px'};
    height: ${isTablet ? '64px' : '52px'};
    border-radius: 50%;
    background: rgba(255,255,255,0.12);
    border: 2px solid rgba(255,255,255,0.25);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: ${isTablet ? '28px' : '22px'};
    color: #fff;
    box-shadow: 0 4px 15px rgba(0,0,0,0.4);
  }
  .score-pill {
    padding: ${isTablet ? '12px 28px' : '9px 20px'};
    background: rgba(0, 32, 91, 0.85);
    border: 2px solid #FFD166;
    border-radius: 999px;
    font-size: ${isTablet ? '24px' : '18px'};
    font-weight: 800;
    color: #FFD166;
    display: flex;
    align-items: center;
    gap: 8px;
    box-shadow: 0 0 20px rgba(255, 209, 102, 0.4);
  }

  .hero-emblem-svg {
    width: 100%;
    height: 100%;
  }

  /* Action Buttons */
  .btn-pj {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 16px;
    width: 100%;
    padding: ${isTablet ? '24px 32px' : '18px 24px'};
    border-radius: ${isTablet ? '28px' : '22px'};
    font-size: ${isTablet ? '32px' : '23px'};
    font-weight: 900;
    text-transform: uppercase;
    letter-spacing: 1px;
    color: #fff;
    border: none;
    cursor: pointer;
    box-shadow: 0 10px 25px rgba(0,0,0,0.5);
  }
  .btn-pj-blue {
    background: linear-gradient(180deg, #0080FF 0%, #0044CC 100%);
    border: 3px solid #00F0FF;
    box-shadow: 0 0 30px rgba(0, 114, 255, 0.6);
  }
  .btn-pj-green {
    background: linear-gradient(180deg, #2EC4B6 0%, #0F8B8D 100%);
    border: 3px solid #70E000;
    box-shadow: 0 0 30px rgba(112, 224, 0, 0.5);
  }
  .btn-pj-yellow {
    background: linear-gradient(180deg, #FFB703 0%, #FB8500 100%);
    border: 3px solid #FFE6A7;
    color: #001845;
    box-shadow: 0 0 30px rgba(255, 183, 3, 0.5);
  }
  .btn-pj-red {
    background: linear-gradient(180deg, #FF4D6D 0%, #C9184A 100%);
    border: 3px solid #FF758F;
    box-shadow: 0 0 30px rgba(255, 77, 109, 0.5);
  }
</style>
</head>
<body>
  <div class="bg-stars"></div>
  <div class="bg-nebula"></div>
  <div class="hero-rays"></div>

  <div class="container">
    <div class="header-banner">
      <div class="badge-tag">⭐ ${badgeText}</div>
      <div class="headline">${headline}</div>
      <div class="subtitle">${subtitle}</div>
    </div>

    <div class="device-mockup-frame">
      <div class="status-bar">
        <span>9:41</span>
        <div class="status-bar-icons">
          <span>●●●●</span>
          <span>5G</span>
          <span>100%</span>
        </div>
      </div>

      <div class="screen-view">
        ${screenContentHtml}
      </div>
    </div>
  </div>
</body>
</html>`;
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN 1: MAIN MENU & HERO HEADQUARTERS
// ─────────────────────────────────────────────────────────────────────────────
function getScreen1Html(isTablet) {
  return `
  <style>
    .menu-wrap {
      display: flex;
      flex-direction: column;
      height: 100%;
      justify-content: space-between;
    }
    .hq-hero-stage {
      display: flex;
      flex-direction: column;
      align-items: center;
      margin-top: ${isTablet ? '20px' : '10px'};
    }
    .hero-totem-logo {
      display: flex;
      align-items: center;
      gap: 16px;
      margin-bottom: ${isTablet ? '24px' : '14px'};
    }
    .totem-icon-box {
      width: ${isTablet ? '110px' : '84px'};
      height: ${isTablet ? '110px' : '84px'};
      background: linear-gradient(135deg, #0052cc, #001845);
      border: 3px solid #00f0ff;
      border-radius: 24px;
      padding: 8px;
      box-shadow: 0 0 30px rgba(0,212,255,0.7);
    }
    .totem-title-box h1 {
      font-size: ${isTablet ? '54px' : '38px'};
      font-weight: 900;
      color: #FFFFFF;
      letter-spacing: 1px;
      text-transform: uppercase;
      text-shadow: 0 4px 15px rgba(0, 114, 255, 0.8);
    }
    .totem-title-box p {
      font-size: ${isTablet ? '26px' : '18px'};
      font-weight: 700;
      color: #00F0FF;
      letter-spacing: 4px;
      text-transform: uppercase;
    }

    /* Hero Trio Showcase Row */
    .hero-trio-row {
      display: flex;
      justify-content: center;
      gap: ${isTablet ? '36px' : '18px'};
      margin: ${isTablet ? '30px 0' : '18px 0'};
      width: 100%;
    }
    .hero-avatar-card {
      flex: 1;
      max-width: ${isTablet ? '260px' : '190px'};
      background: rgba(4, 16, 51, 0.85);
      border-radius: ${isTablet ? '30px' : '22px'};
      padding: ${isTablet ? '24px 16px' : '16px 12px'};
      display: flex;
      flex-direction: column;
      align-items: center;
      box-shadow: 0 10px 25px rgba(0,0,0,0.6);
      transition: all 0.3s ease;
    }
    .card-catboy { border: 3px solid #00D4FF; box-shadow: 0 0 30px rgba(0, 212, 255, 0.4); }
    .card-owlette { border: 3px solid #FF5D8F; box-shadow: 0 0 30px rgba(255, 93, 143, 0.4); }
    .card-gekko { border: 3px solid #52B788; box-shadow: 0 0 30px rgba(82, 183, 136, 0.4); }

    .avatar-icon-wrap {
      width: ${isTablet ? '110px' : '80px'};
      height: ${isTablet ? '110px' : '80px'};
      margin-bottom: 12px;
    }
    .avatar-name {
      font-size: ${isTablet ? '26px' : '18px'};
      font-weight: 900;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    .avatar-role {
      font-size: ${isTablet ? '18px' : '13px'};
      font-weight: 700;
      opacity: 0.8;
      margin-top: 4px;
    }

    /* Menu Buttons Column */
    .menu-action-list {
      display: flex;
      flex-direction: column;
      gap: ${isTablet ? '24px' : '16px'};
      width: 100%;
      max-width: ${isTablet ? '800px' : '100%'};
      margin: 0 auto;
    }

    .footer-licensing {
      text-align: center;
      font-size: ${isTablet ? '18px' : '13px'};
      font-weight: 600;
      color: rgba(255,255,255,0.6);
      letter-spacing: 1px;
      margin-top: 16px;
    }
  </style>

  <div class="menu-wrap">
    <div class="app-nav-bar">
      <div class="nav-btn">🔊</div>
      <div class="score-badge-wrap">
        <div class="score-pill">⭐ 2,450 PTS</div>
      </div>
      <div class="nav-btn">🛡️</div>
    </div>

    <div class="hq-hero-stage">
      <div class="hero-totem-logo">
        <div class="totem-icon-box">
          ${CATBOY_EMBLEM}
        </div>
        <div class="totem-title-box">
          <h1>PJ Masks</h1>
          <p>Time to be a Hero VR</p>
        </div>
      </div>

      <!-- Hero Trio Showcase -->
      <div class="hero-trio-row">
        <div class="hero-avatar-card card-catboy">
          <div class="avatar-icon-wrap">${CATBOY_EMBLEM}</div>
          <div class="avatar-name" style="color:#00F0FF;">Catboy</div>
          <div class="avatar-role">Super Speed</div>
        </div>

        <div class="hero-avatar-card card-owlette">
          <div class="avatar-icon-wrap">${OWLETTE_EMBLEM}</div>
          <div class="avatar-name" style="color:#FF758F;">Owlette</div>
          <div class="avatar-role">Super Wings</div>
        </div>

        <div class="hero-avatar-card card-gekko">
          <div class="avatar-icon-wrap">${GEKKO_EMBLEM}</div>
          <div class="avatar-name" style="color:#74C69D;">Gekko</div>
          <div class="avatar-role">Super Muscles</div>
        </div>
      </div>
    </div>

    <div class="menu-action-list">
      <button class="btn-pj btn-pj-blue">🎮 Play Mini-Games</button>
      <button class="btn-pj btn-pj-green">📷 AR Hero Mask Camera</button>
      <button class="btn-pj btn-pj-yellow">⭐ Hero Selection & Powers</button>
      <button class="btn-pj btn-pj-red">🥽 VR Experience Mode</button>
    </div>

    <div class="footer-licensing">
      <span>Official Entertainment One & CAS.AI Kids Safe Certified</span>
    </div>
  </div>`;
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN 2: REAL-TIME AR HERO MASKS
// ─────────────────────────────────────────────────────────────────────────────
function getScreen2Html(isTablet) {
  return `
  <style>
    .ar-viewport {
      display: flex;
      flex-direction: column;
      height: 100%;
      position: relative;
    }
    .ar-camera-feed {
      position: absolute;
      inset: 0;
      background: radial-gradient(circle at center, #0f2c59 0%, #05142b 60%, #020914 100%);
      border-radius: ${isTablet ? '36px' : '28px'};
      overflow: hidden;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
    }

    /* Face tracking reticle overlay */
    .ar-target-reticle {
      position: absolute;
      width: ${isTablet ? '580px' : '440px'};
      height: ${isTablet ? '580px' : '440px'};
      border: 2px dashed rgba(0, 240, 255, 0.4);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .tracking-badge {
      position: absolute;
      top: 20px;
      background: rgba(0, 240, 255, 0.2);
      border: 1px solid #00F0FF;
      color: #00F0FF;
      padding: 6px 18px;
      border-radius: 20px;
      font-size: ${isTablet ? '20px' : '14px'};
      font-weight: 800;
      letter-spacing: 2px;
      text-transform: uppercase;
      box-shadow: 0 0 15px rgba(0, 240, 255, 0.5);
    }

    .ar-mask-center {
      width: ${isTablet ? '520px' : '390px'};
      height: ${isTablet ? '460px' : '350px'};
      z-index: 5;
      filter: drop-shadow(0 0 35px rgba(0, 212, 255, 0.8));
    }

    .ar-power-hud {
      position: absolute;
      top: ${isTablet ? '110px' : '85px'};
      left: 30px;
      right: 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      z-index: 10;
    }
    .power-gauge {
      background: rgba(2, 10, 30, 0.8);
      border: 2px solid #00D4FF;
      border-radius: 20px;
      padding: ${isTablet ? '14px 24px' : '10px 16px'};
      display: flex;
      align-items: center;
      gap: 12px;
      box-shadow: 0 0 20px rgba(0, 212, 255, 0.4);
    }
    .power-label {
      font-size: ${isTablet ? '22px' : '15px'};
      font-weight: 900;
      color: #00F0FF;
      letter-spacing: 1px;
    }
    .power-bar {
      width: ${isTablet ? '180px' : '120px'};
      height: ${isTablet ? '16px' : '12px'};
      background: rgba(255,255,255,0.15);
      border-radius: 8px;
      overflow: hidden;
    }
    .power-bar-fill {
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, #00D4FF, #00F0FF);
      box-shadow: 0 0 10px #00F0FF;
    }

    /* AR Bottom Controls */
    .ar-bottom-controls {
      position: absolute;
      bottom: ${isTablet ? '40px' : '26px'};
      left: 20px;
      right: 20px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: ${isTablet ? '26px' : '18px'};
      z-index: 10;
    }

    /* Hero Selector Row */
    .ar-hero-strip {
      display: flex;
      gap: ${isTablet ? '24px' : '16px'};
      background: rgba(2, 8, 25, 0.85);
      padding: ${isTablet ? '12px 24px' : '8px 16px'};
      border-radius: 999px;
      border: 2px solid rgba(255,255,255,0.2);
      backdrop-filter: blur(10px);
    }
    .ar-hero-pill {
      width: ${isTablet ? '76px' : '58px'};
      height: ${isTablet ? '76px' : '58px'};
      border-radius: 50%;
      padding: 6px;
      border: 3px solid transparent;
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(255,255,255,0.08);
      cursor: pointer;
    }
    .pill-active {
      border-color: #00F0FF;
      background: rgba(0, 212, 255, 0.25);
      box-shadow: 0 0 20px #00F0FF;
    }

    /* Shutter Button */
    .ar-shutter-row {
      display: flex;
      align-items: center;
      gap: ${isTablet ? '50px' : '36px'};
    }
    .btn-shutter {
      width: ${isTablet ? '100px' : '80px'};
      height: ${isTablet ? '100px' : '80px'};
      border-radius: 50%;
      background: #FFFFFF;
      border: 6px solid #00F0FF;
      box-shadow: 0 0 35px rgba(0, 240, 255, 0.8);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: ${isTablet ? '42px' : '34px'};
    }
    .btn-flip {
      width: ${isTablet ? '64px' : '50px'};
      height: ${isTablet ? '64px' : '50px'};
      border-radius: 50%;
      background: rgba(2, 10, 30, 0.8);
      border: 2px solid #00D4FF;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: ${isTablet ? '26px' : '20px'};
      color: #fff;
    }
  </style>

  <div class="ar-viewport">
    <div class="app-nav-bar" style="position:relative; z-index:15;">
      <div class="nav-btn">←</div>
      <div class="score-pill">📷 AR HERO MODE</div>
      <div class="nav-btn">⚡</div>
    </div>

    <div class="ar-camera-feed">
      <div class="ar-target-reticle">
        <div class="tracking-badge">● FACE TRACKING ACTIVE 100%</div>
      </div>

      <div class="ar-power-hud">
        <div class="power-gauge">
          <span style="font-size:${isTablet ? '26px' : '18px'};">⚡</span>
          <div>
            <div class="power-label">SUPER CAT SPEED</div>
            <div class="power-bar"><div class="power-bar-fill"></div></div>
          </div>
        </div>
        <div class="power-gauge">
          <span style="font-size:${isTablet ? '26px' : '18px'};">✨</span>
          <div class="power-label">HERO GLOW: ON</div>
        </div>
      </div>

      <!-- Render Mask -->
      <div class="ar-mask-center">
        ${CATBOY_AR_MASK_DETAILED}
      </div>

      <!-- Bottom Controls -->
      <div class="ar-bottom-controls">
        <div class="ar-hero-strip">
          <div class="ar-hero-pill pill-active">${CATBOY_EMBLEM}</div>
          <div class="ar-hero-pill">${OWLETTE_EMBLEM}</div>
          <div class="ar-hero-pill">${GEKKO_EMBLEM}</div>
        </div>

        <div class="ar-shutter-row">
          <div class="btn-flip">🔄</div>
          <div class="btn-shutter">📸</div>
          <div class="btn-flip">⭐</div>
        </div>
      </div>
    </div>
  </div>`;
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN 3: HERO SELECTION & SUPERPOWERS
// ─────────────────────────────────────────────────────────────────────────────
function getScreen3Html(isTablet) {
  return `
  <style>
    .hero-select-wrap {
      display: flex;
      flex-direction: column;
      height: 100%;
      justify-content: space-between;
    }
    .select-title-box {
      text-align: center;
      margin-bottom: ${isTablet ? '24px' : '14px'};
    }
    .select-title-box h2 {
      font-size: ${isTablet ? '42px' : '30px'};
      font-weight: 900;
      color: #FFFFFF;
      letter-spacing: 1px;
      text-transform: uppercase;
    }
    .select-title-box p {
      font-size: ${isTablet ? '22px' : '16px'};
      color: #00F0FF;
      font-weight: 700;
      margin-top: 4px;
    }

    /* Hero Cards Column */
    .hero-cards-col {
      display: flex;
      flex-direction: ${isTablet ? 'row' : 'column'};
      gap: ${isTablet ? '24px' : '16px'};
      flex: 1;
      justify-content: center;
    }
    .hero-detail-card {
      flex: 1;
      background: linear-gradient(135deg, rgba(4, 18, 54, 0.95) 0%, rgba(2, 9, 28, 0.95) 100%);
      border-radius: ${isTablet ? '32px' : '24px'};
      padding: ${isTablet ? '28px 24px' : '18px 20px'};
      display: flex;
      flex-direction: ${isTablet ? 'column' : 'row'};
      align-items: center;
      gap: ${isTablet ? '20px' : '18px'};
      box-shadow: 0 12px 30px rgba(0,0,0,0.6);
      position: relative;
    }
    .card-border-catboy { border: 3px solid #00D4FF; box-shadow: 0 0 30px rgba(0, 212, 255, 0.4); }
    .card-border-owlette { border: 3px solid #FF5D8F; box-shadow: 0 0 30px rgba(255, 93, 143, 0.4); }
    .card-border-gekko { border: 3px solid #52B788; box-shadow: 0 0 30px rgba(82, 183, 136, 0.4); }

    .card-left-emblem {
      width: ${isTablet ? '130px' : '90px'};
      height: ${isTablet ? '130px' : '90px'};
      flex-shrink: 0;
    }
    .card-info {
      flex: 1;
      display: flex;
      flex-direction: column;
      gap: 6px;
      width: 100%;
    }
    .hero-title-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .hero-main-name {
      font-size: ${isTablet ? '32px' : '24px'};
      font-weight: 900;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    .hero-active-badge {
      font-size: ${isTablet ? '18px' : '13px'};
      font-weight: 800;
      padding: 4px 12px;
      border-radius: 999px;
      background: #00F0FF;
      color: #001845;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    .hero-ability-text {
      font-size: ${isTablet ? '20px' : '15px'};
      font-weight: 700;
      color: #E0E7FF;
    }

    /* Stat Bars */
    .stat-row {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-top: 4px;
    }
    .stat-name {
      font-size: ${isTablet ? '18px' : '13px'};
      font-weight: 700;
      width: ${isTablet ? '110px' : '85px'};
      color: #94A3B8;
    }
    .stat-track {
      flex: 1;
      height: ${isTablet ? '14px' : '10px'};
      background: rgba(255,255,255,0.12);
      border-radius: 6px;
      overflow: hidden;
    }
    .stat-fill {
      height: 100%;
      border-radius: 6px;
    }

    .bottom-cta-banner {
      background: rgba(0, 82, 204, 0.3);
      border: 2px dashed #00D4FF;
      border-radius: 20px;
      padding: ${isTablet ? '20px' : '14px'};
      text-align: center;
      margin-top: ${isTablet ? '24px' : '14px'};
    }
    .bottom-cta-banner p {
      font-size: ${isTablet ? '22px' : '16px'};
      font-weight: 800;
      color: #FFD166;
      letter-spacing: 1px;
    }
  </style>

  <div class="hero-select-wrap">
    <div class="app-nav-bar">
      <div class="nav-btn">←</div>
      <div class="score-pill">⭐ HERO ROSTER</div>
      <div class="nav-btn">🏆</div>
    </div>

    <div class="select-title-box">
      <h2>Choose Your Superhero</h2>
      <p>Master unique powers & save the city!</p>
    </div>

    <div class="hero-cards-col">
      <!-- Catboy -->
      <div class="hero-detail-card card-border-catboy">
        <div class="card-left-emblem">${CATBOY_EMBLEM}</div>
        <div class="card-info">
          <div class="hero-title-row">
            <span class="hero-main-name" style="color:#00F0FF;">Catboy</span>
            <span class="hero-active-badge">ACTIVE HERO</span>
          </div>
          <div class="hero-ability-text">⚡ Super Cat Speed & Super Cat Leap</div>
          <div class="stat-row">
            <span class="stat-name">SPEED</span>
            <div class="stat-track"><div class="stat-fill" style="width:98%; background:#00D4FF; box-shadow:0 0 8px #00D4FF;"></div></div>
          </div>
          <div class="stat-row">
            <span class="stat-name">AGILITY</span>
            <div class="stat-track"><div class="stat-fill" style="width:92%; background:#0080FF;"></div></div>
          </div>
        </div>
      </div>

      <!-- Owlette -->
      <div class="hero-detail-card card-border-owlette">
        <div class="card-left-emblem">${OWLETTE_EMBLEM}</div>
        <div class="card-info">
          <div class="hero-title-row">
            <span class="hero-main-name" style="color:#FF758F;">Owlette</span>
            <span class="hero-active-badge" style="background:#FF758F;">UNLOCKED</span>
          </div>
          <div class="hero-ability-text">🪶 Super Owl Wings & Owl Eyes</div>
          <div class="stat-row">
            <span class="stat-name">FLIGHT</span>
            <div class="stat-track"><div class="stat-fill" style="width:100%; background:#FF5D8F; box-shadow:0 0 8px #FF5D8F;"></div></div>
          </div>
          <div class="stat-row">
            <span class="stat-name">VISION</span>
            <div class="stat-track"><div class="stat-fill" style="width:95%; background:#D90429;"></div></div>
          </div>
        </div>
      </div>

      <!-- Gekko -->
      <div class="hero-detail-card card-border-gekko">
        <div class="card-left-emblem">${GEKKO_EMBLEM}</div>
        <div class="card-info">
          <div class="hero-title-row">
            <span class="hero-main-name" style="color:#74C69D;">Gekko</span>
            <span class="hero-active-badge" style="background:#52B788;">UNLOCKED</span>
          </div>
          <div class="hero-ability-text">💪 Super Gekko Muscles & Camouflage</div>
          <div class="stat-row">
            <span class="stat-name">STRENGTH</span>
            <div class="stat-track"><div class="stat-fill" style="width:100%; background:#52B788; box-shadow:0 0 8px #52B788;"></div></div>
          </div>
          <div class="stat-row">
            <span class="stat-name">SHIELD</span>
            <div class="stat-track"><div class="stat-fill" style="width:94%; background:#2D6A4F;"></div></div>
          </div>
        </div>
      </div>
    </div>

    <div class="bottom-cta-banner">
      <p>⭐ Earn Stars in Night Missions to Upgrade Hero Skills!</p>
    </div>
  </div>`;
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN 4: SMELLY SPRAY MINI-GAME ACTION
// ─────────────────────────────────────────────────────────────────────────────
function getScreen4Html(isTablet) {
  return `
  <style>
    .game-playfield {
      display: flex;
      flex-direction: column;
      height: 100%;
      position: relative;
      background: linear-gradient(180deg, #071739 0%, #030a1c 100%);
      border-radius: ${isTablet ? '36px' : '26px'};
      overflow: hidden;
    }

    /* Game HUD Top */
    .game-hud-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: ${isTablet ? '20px 28px' : '14px 20px'};
      background: rgba(2, 8, 25, 0.85);
      border-bottom: 2px solid rgba(0, 212, 255, 0.3);
      z-index: 10;
    }
    .hud-stat-box {
      display: flex;
      flex-direction: column;
    }
    .hud-stat-title {
      font-size: ${isTablet ? '18px' : '13px'};
      font-weight: 700;
      color: #94A3B8;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    .hud-stat-val {
      font-size: ${isTablet ? '36px' : '26px'};
      font-weight: 900;
      color: #00F0FF;
    }
    .combo-pill {
      background: linear-gradient(90deg, #FFB703, #FB8500);
      color: #001845;
      padding: ${isTablet ? '8px 22px' : '6px 16px'};
      border-radius: 999px;
      font-size: ${isTablet ? '22px' : '16px'};
      font-weight: 900;
      letter-spacing: 1px;
      box-shadow: 0 0 20px rgba(255, 183, 3, 0.7);
    }
    .lives-row {
      font-size: ${isTablet ? '32px' : '24px'};
    }

    /* City Rooftop Play Arena */
    .arena-skyline {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      height: ${isTablet ? '260px' : '180px'};
      background:
        linear-gradient(to top, #010614 0%, transparent 100%),
        repeating-linear-gradient(90deg, #091738 0px, #091738 40px, #040c1e 40px, #040c1e 80px);
      opacity: 0.8;
      border-top: 2px solid #0052cc;
    }

    /* Stinky Clouds */
    .cloud-smelly {
      position: absolute;
      border-radius: 50%;
      background: radial-gradient(circle at 40% 40%, #BF5AF2 0%, #7B2CBF 60%, #3C096C 100%);
      border: 3px solid #E0AAFF;
      box-shadow: 0 0 35px rgba(191, 90, 242, 0.75);
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      cursor: pointer;
    }
    .cloud-1 {
      top: 22%;
      left: 18%;
      width: ${isTablet ? '200px' : '150px'};
      height: ${isTablet ? '170px' : '125px'};
    }
    .cloud-2 {
      top: 36%;
      right: 14%;
      width: ${isTablet ? '240px' : '170px'};
      height: ${isTablet ? '190px' : '140px'};
    }
    .cloud-3 {
      top: 55%;
      left: 32%;
      width: ${isTablet ? '220px' : '160px'};
      height: ${isTablet ? '180px' : '130px'};
    }

    /* Splatter burst popup */
    .burst-effect {
      position: absolute;
      top: 32%;
      right: 12%;
      z-index: 15;
      display: flex;
      flex-direction: column;
      align-items: center;
      animation: floatUp 1s ease-out;
    }
    .burst-text {
      font-size: ${isTablet ? '42px' : '32px'};
      font-weight: 900;
      color: #70E000;
      text-shadow: 0 0 20px #70E000, 0 4px 10px #000;
      letter-spacing: 2px;
    }
    .burst-sub {
      font-size: ${isTablet ? '24px' : '18px'};
      font-weight: 800;
      color: #FFD166;
      text-shadow: 0 0 15px #FFD166;
    }

    /* Hero Side Cheer */
    .hero-cheer-avatar {
      position: absolute;
      bottom: ${isTablet ? '30px' : '20px'};
      left: ${isTablet ? '30px' : '20px'};
      display: flex;
      align-items: center;
      gap: 16px;
      background: rgba(2, 10, 30, 0.9);
      border: 2px solid #00F0FF;
      border-radius: 999px;
      padding: ${isTablet ? '12px 28px' : '8px 18px'};
      box-shadow: 0 0 25px rgba(0, 240, 255, 0.4);
      z-index: 20;
    }
    .cheer-icon {
      width: ${isTablet ? '56px' : '42px'};
      height: ${isTablet ? '56px' : '42px'};
    }
    .cheer-quote {
      font-size: ${isTablet ? '22px' : '16px'};
      font-weight: 800;
      color: #FFFFFF;
    }
  </style>

  <div class="game-playfield">
    <div class="game-hud-bar">
      <div class="hud-stat-box">
        <span class="hud-stat-title">SCORE</span>
        <span class="hud-stat-val">5,680</span>
      </div>

      <div class="combo-pill">🔥 4x COMBO!</div>

      <div class="hud-stat-box" style="align-items: flex-end;">
        <span class="hud-stat-title">LIVES</span>
        <div class="lives-row">❤️❤️❤️</div>
      </div>
    </div>

    <!-- Active Gas Clouds -->
    <div class="cloud-smelly cloud-1">
      <span style="font-size:${isTablet ? '46px' : '36px'};">☠️</span>
      <span style="font-size:${isTablet ? '18px' : '13px'}; font-weight:800; color:#E0AAFF;">TAP!</span>
    </div>

    <div class="cloud-smelly cloud-3">
      <span style="font-size:${isTablet ? '46px' : '36px'};">☠️</span>
      <span style="font-size:${isTablet ? '18px' : '13px'}; font-weight:800; color:#E0AAFF;">TAP!</span>
    </div>

    <!-- Popped Splatter Burst -->
    <div class="burst-effect">
      <div class="burst-text">SUPER CLEAN! 💨</div>
      <div class="burst-sub">+250 PTS</div>
    </div>

    <!-- Rooftop Skyline -->
    <div class="arena-skyline"></div>

    <!-- Hero Companion Cheer -->
    <div class="hero-cheer-avatar">
      <div class="cheer-icon">${CATBOY_EMBLEM}</div>
      <span class="cheer-quote">Catboy: "Lightning fast reflexes!"</span>
    </div>
  </div>`;
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN 5: ROMEO'S FLYING ROBOTS SLINGSHOT BATTLE
// ─────────────────────────────────────────────────────────────────────────────
function getScreen5Html(isTablet) {
  return `
  <style>
    .battle-playfield {
      display: flex;
      flex-direction: column;
      height: 100%;
      position: relative;
      background: radial-gradient(circle at 50% 30%, #150936 0%, #08031d 60%, #02010c 100%);
      border-radius: ${isTablet ? '36px' : '26px'};
      overflow: hidden;
    }

    /* Battle HUD */
    .battle-hud-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: ${isTablet ? '20px 28px' : '14px 20px'};
      background: rgba(8, 2, 24, 0.85);
      border-bottom: 2px solid rgba(255, 93, 143, 0.4);
      z-index: 10;
    }
    .wave-badge {
      background: #D90429;
      color: #fff;
      padding: ${isTablet ? '8px 22px' : '6px 16px'};
      border-radius: 999px;
      font-size: ${isTablet ? '22px' : '16px'};
      font-weight: 900;
      box-shadow: 0 0 20px rgba(217, 4, 41, 0.6);
    }

    /* Robot Target Drone */
    .robot-drone {
      position: absolute;
      width: ${isTablet ? '160px' : '120px'};
      height: ${isTablet ? '130px' : '95px'};
      background: linear-gradient(135deg, #4A4E69 0%, #22223B 100%);
      border: 3px solid #F72585;
      border-radius: 20px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      box-shadow: 0 0 30px rgba(247, 37, 133, 0.5);
    }
    .drone-1 { top: 22%; left: 16%; }
    .drone-2 { top: 18%; right: 18%; }
    .drone-eyes {
      display: flex;
      gap: 12px;
      margin-bottom: 6px;
    }
    .eye-red {
      width: 14px;
      height: 14px;
      border-radius: 50%;
      background: #FF0055;
      box-shadow: 0 0 10px #FF0055;
    }

    /* Direct Hit Explosion */
    .hit-explosion {
      position: absolute;
      top: 36%;
      left: 50%;
      transform: translate(-50%, -50%);
      display: flex;
      flex-direction: column;
      align-items: center;
      z-index: 15;
    }
    .hit-blast-svg {
      width: ${isTablet ? '240px' : '180px'};
      height: ${isTablet ? '240px' : '180px'};
      filter: drop-shadow(0 0 35px #FFB703);
    }
    .hit-title {
      font-size: ${isTablet ? '46px' : '34px'};
      font-weight: 900;
      color: #FFB703;
      text-shadow: 0 0 25px #FFB703, 0 4px 10px #000;
      letter-spacing: 2px;
      margin-top: -20px;
    }

    /* Slingshot Base & Trajectory */
    .slingshot-station {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      height: ${isTablet ? '380px' : '280px'};
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: flex-end;
      padding-bottom: ${isTablet ? '40px' : '24px'};
    }
    .aiming-arc-svg {
      position: absolute;
      bottom: ${isTablet ? '120px' : '90px'};
      width: ${isTablet ? '400px' : '300px'};
      height: ${isTablet ? '300px' : '220px'};
    }
    .slingshot-rig {
      width: ${isTablet ? '160px' : '120px'};
      height: ${isTablet ? '130px' : '100px'};
      background: linear-gradient(180deg, #0052CC 0%, #001845 100%);
      border: 4px solid #00F0FF;
      border-radius: 30px;
      box-shadow: 0 0 35px rgba(0, 240, 255, 0.7);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: ${isTablet ? '50px' : '38px'};
      z-index: 20;
    }
  </style>

  <div class="battle-playfield">
    <div class="battle-hud-bar">
      <div class="hud-stat-box">
        <span class="hud-stat-title">SCORE</span>
        <span class="hud-stat-val">12,450</span>
      </div>

      <div class="wave-badge">⚡ WAVE 4 / 5</div>

      <div class="hud-stat-box" style="align-items: flex-end;">
        <span class="hud-stat-title">BOTS DOWN</span>
        <span class="hud-stat-val" style="color:#FFB703;">18</span>
      </div>
    </div>

    <!-- Flying Enemy Drones -->
    <div class="robot-drone drone-1">
      <div class="drone-eyes"><div class="eye-red"></div><div class="eye-red"></div></div>
      <span style="font-size:${isTablet ? '22px' : '16px'}; font-weight:800; color:#F72585;">BOT #1</span>
    </div>

    <div class="robot-drone drone-2">
      <div class="drone-eyes"><div class="eye-red"></div><div class="eye-red"></div></div>
      <span style="font-size:${isTablet ? '22px' : '16px'}; font-weight:800; color:#F72585;">BOT #2</span>
    </div>

    <!-- Explosion Burst on Target -->
    <div class="hit-explosion">
      <svg class="hit-blast-svg" viewBox="0 0 100 100">
        <polygon points="50,5 64,36 98,38 72,60 82,92 50,74 18,92 28,60 2,38 36,36" fill="#FFB703" stroke="#FF5400" stroke-width="3"/>
        <polygon points="50,20 60,40 82,42 66,54 72,76 50,64 28,76 34,54 18,42 40,40" fill="#FFF" />
      </svg>
      <div class="hit-title">DIRECT HIT! 💥</div>
      <div style="font-size:${isTablet ? '26px' : '18px'}; font-weight:800; color:#00F0FF;">+500 COMBO BONUS!</div>
    </div>

    <!-- Slingshot Launcher & Aiming Line -->
    <div class="slingshot-station">
      <svg class="aiming-arc-svg" viewBox="0 0 200 200">
        <path d="M100 180 Q80 80 100 20" stroke="#00F0FF" stroke-width="4" stroke-dasharray="8 8" fill="none"/>
        <circle cx="100" cy="20" r="12" stroke="#FF0055" stroke-width="4" fill="none"/>
        <circle cx="100" cy="20" r="4" fill="#FF0055"/>
      </svg>
      <div class="slingshot-rig">🎯</div>
    </div>
  </div>`;
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREENSHOT DEFINITIONS
// ─────────────────────────────────────────────────────────────────────────────
const SCREENS = [
  {
    id: '1_main_menu',
    badgeText: 'HERO HEADQUARTERS',
    headline: 'TIME TO BE A HERO!',
    subtitle: 'Step into the night to save the day with Catboy, Owlette & Gekko',
    contentFn: getScreen1Html,
  },
  {
    id: '2_ar_masks',
    badgeText: 'AUGMENTED REALITY',
    headline: 'REAL-TIME AR HERO MASKS!',
    subtitle: 'Transform into your favorite hero with live face-tracking & power effects',
    contentFn: getScreen2Html,
  },
  {
    id: '3_hero_select',
    badgeText: 'SUPERPOWER ROSTER',
    headline: 'UNLOCK SUPER HERO POWERS!',
    subtitle: 'Super Cat Speed, Super Owl Wings & Super Gekko Muscles',
    contentFn: getScreen3Html,
  },
  {
    id: '4_smelly_spray',
    badgeText: 'ACTION MINI-GAME',
    headline: 'STOP THE SMELLY SPRAY!',
    subtitle: 'Tap Romeo’s noxious clouds before they spread across the city',
    contentFn: getScreen4Html,
  },
  {
    id: '5_romeo_shoot',
    badgeText: 'VILLAIN SHOWDOWN',
    headline: 'SLINGSHOT ROBOT BATTLE!',
    subtitle: 'Aim, slingshot & blast flying villain drones out of the midnight sky',
    contentFn: getScreen5Html,
  },
];

async function generateAll() {
  console.log('🚀 Starting High-Res App Store Screenshot Generation...');

  const devices = [
    {
      name: 'iPhone 6.1"',
      width: 1179,
      height: 2556,
      outDir: OUT_DIR_IPHONE,
      isTablet: false,
    },
    {
      name: 'iPad 12.9"',
      width: 2048,
      height: 2732,
      outDir: OUT_DIR_IPAD,
      isTablet: true,
    },
  ];

  for (const device of devices) {
    console.log(`\n📱 Generating for ${device.name} (${device.width}x${device.height})...`);
    for (const screen of SCREENS) {
      const screenHtml = generateHtml({
        width: device.width,
        height: device.height,
        isTablet: device.isTablet,
        badgeText: screen.badgeText,
        headline: screen.headline,
        subtitle: screen.subtitle,
        screenContentHtml: screen.contentFn(device.isTablet),
      });

      const tempHtmlPath = path.join('/tmp', `screen_${device.isTablet ? 'ipad' : 'iphone'}_${screen.id}.html`);
      fs.writeFileSync(tempHtmlPath, screenHtml);

      const outPngPath = path.join(device.outDir, `${screen.id}.png`);
      const tempUserData = path.join('/tmp', `chrome-data-${Date.now()}-${Math.random().toString(36).substring(7)}`);

      const cmd = `"${CHROME_PATH}" --headless --no-sandbox --disable-gpu --user-data-dir="${tempUserData}" --screenshot="${outPngPath}" --window-size=${device.width},${device.height} "file://${tempHtmlPath}"`;

      try {
        execSync(cmd, { stdio: 'pipe' });
        console.log(`  ✅ Generated: ${path.basename(outPngPath)}`);
      } catch (err) {
        console.error(`  ❌ Failed generating ${outPngPath}:`, err.message);
      } finally {
        fs.rmSync(tempHtmlPath, { force: true });
        fs.rmSync(tempUserData, { recursive: true, force: true });
      }
    }
  }

  console.log('\n🎉 All screenshots generated successfully!');
}

generateAll();
