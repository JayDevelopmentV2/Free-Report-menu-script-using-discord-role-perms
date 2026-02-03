window.addEventListener('message', function (event) {
    const data = event.data;

    if (data.action === 'openReportUI') {
        document.getElementById('app').classList.remove('hidden');
        document.getElementById('playerReportUI').classList.remove('hidden');
        document.getElementById('adminReportUI').classList.add('hidden');
    } else if (data.action === 'openAdminUI') {
        document.getElementById('app').classList.remove('hidden');
        document.getElementById('adminReportUI').classList.remove('hidden');
        document.getElementById('playerReportUI').classList.add('hidden');
        loadReports(data.reports || []);
    } else if (data.action === 'closeUI') {
        closeUI();
    } else if (data.action === 'updateReports') {
        loadReports(data.reports || []);
    }
});

function closeUI() {
    const playerUI = document.getElementById('playerReportUI');
    const adminUI = document.getElementById('adminReportUI');

    if (!playerUI.classList.contains('hidden')) {
        playerUI.classList.add('closing');
    }
    if (!adminUI.classList.contains('hidden')) {
        adminUI.classList.add('closing');
    }

    setTimeout(() => {
        document.getElementById('app').classList.add('hidden');
        playerUI.classList.add('hidden');
        adminUI.classList.add('hidden');
        playerUI.classList.remove('closing');
        adminUI.classList.remove('closing');

        const form = document.getElementById('reportForm');
        if (form) form.reset();
    }, 200);
}

function sendCloseCallback() {
    fetch(`https://${RESOURCE_NAME}/closeUI`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).then(() => {
        closeUI();
    }).catch(() => {
        closeUI();
    });
}

document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') {
        const app = document.getElementById('app');
        if (!app.classList.contains('hidden')) {
            sendCloseCallback();
        }
    }
});

function submitReport(event) {
    event.preventDefault();

    const title = document.getElementById('reportTitle').value.trim();
    const description = document.getElementById('reportDescription').value.trim();

    if (!title || !description) return;

    fetch(`https://${RESOURCE_NAME}/submitReport`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title, description })
    });
}

function loadReports(reports) {
    const container = document.getElementById('reportsContainer');
    const noReports = document.getElementById('noReports');

    if (!reports || reports.length === 0) {
        container.innerHTML = '';
        noReports.classList.remove('hidden');
        return;
    }

    noReports.classList.add('hidden');
    container.innerHTML = '';

    reports.forEach(report => {
        const card = document.createElement('div');
        card.className = 'report-card';
        card.innerHTML = `
            <div class="report-header">
                <span class="report-id">#${report.id}</span>
            </div>
            <div class="report-player">
                <i data-lucide="user" class="icon"></i>
                ${escapeHtml(report.reporterName)}
            </div>
            <div class="report-title">${escapeHtml(report.title)}</div>
            <div class="report-description">${escapeHtml(report.description)}</div>
            <div class="report-timestamp">
                <i data-lucide="clock" class="icon"></i>
                ${formatTime(report.timestamp)}
            </div>
            <div class="report-actions">
                <button class="action-btn" onclick="bringPlayer(${report.id})">
                    <i data-lucide="map-pin" class="icon"></i>
                    Bring
                </button>
                <button class="action-btn" onclick="teleportTo(${report.id})">
                    <i data-lucide="move" class="icon"></i>
                    Teleport
                </button>
                <button class="action-btn" onclick="freezePlayer(${report.id})">
                    <i data-lucide="snowflake" class="icon"></i>
                    Freeze
                </button>
                <button class="action-btn" onclick="unfreezePlayer(${report.id})">
                    <i data-lucide="play" class="icon"></i>
                    Unfreeze
                </button>
                <button class="action-btn close-report-btn" onclick="closeReport(${report.id})">
                    <i data-lucide="check" class="icon"></i>
                    Close
                </button>
            </div>
        `;
        container.appendChild(card);
    });

    lucide.createIcons();
}

function bringPlayer(reportId) {
    fetch(`https://${RESOURCE_NAME}/bringPlayer`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ reportId })
    }).catch(() => { });
}

function teleportTo(reportId) {
    fetch(`https://${RESOURCE_NAME}/teleportToPlayer`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ reportId })
    }).catch(() => { });
}

function freezePlayer(reportId) {
    fetch(`https://${RESOURCE_NAME}/freezePlayer`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ reportId })
    }).catch(() => { });
}

function unfreezePlayer(reportId) {
    fetch(`https://${RESOURCE_NAME}/unfreezePlayer`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ reportId })
    }).catch(() => { });
}

function closeReport(reportId) {
    fetch(`https://${RESOURCE_NAME}/closeReport`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ reportId })
    }).catch(() => { });
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function formatTime(timestamp) {
    if (!timestamp) return 'Just now';

    const date = new Date(timestamp);
    const now = new Date();
    const diff = Math.floor((now - date) / 1000);

    if (diff < 60) return 'Just now';
    if (diff < 3600) return `${Math.floor(diff / 60)}m ago`;
    if (diff < 86400) return `${Math.floor(diff / 3600)}h ago`;

    return date.toLocaleDateString();
}

const RESOURCE_NAME = 'reportmenu';
