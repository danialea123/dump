let leaderboardDataSets = {};
let currentTier = 'elite';
let leaderboardData = [];
let currentGangName = '';

function getCupImagePath(tier) {
    return `img/${tier}.png`;
}

function renderLeaderboard(currentGangName) {
    const tbody = document.getElementById('leaderboardBody');
    tbody.innerHTML = '';

    if (!leaderboardData || leaderboardData.length === 0) {
        tbody.innerHTML = `
            <tr class="empty-state">
                <td colspan="4">
                    <i class="empty-icon fa-solid fa-face-sleeping"></i>
                    <p>No rankings available for this tier yet</p>
                </td>
            </tr>
        `;
        return;
    }

    leaderboardData.forEach(entry => {
        const isCurrentGang = entry.name === currentGangName;

        tbody.innerHTML += `
            <tr class="${isCurrentGang ? 'current-gang' : ''}">
                <td>${entry.rank}</td>
                <td class="gname">${entry.name}</td>
                <td><img src="${getCupImagePath(currentTier)}" alt="${currentTier} cup" class="cup-image" /></td>
                <td>${entry.points}🏆</td>
            </tr>
        `;
    });
}

function findGangTier(dataSets) {
    const tierOrder = ['elite', 'champion', 'master', 'legendary', 'gold', 'silver', 'bronze'];
    
    for (const tier of tierOrder) {
        if (dataSets[tier] && dataSets[tier].length > 0) {
            return tier;
        }
    }
    
    return 'bronze';
}

function initializeNavigation() {
    const navLinks = document.querySelectorAll('nav a');
    const nav = document.querySelector('nav');
    
    const activeIndicator = document.createElement('div');
    activeIndicator.className = 'active-indicator';
    nav.appendChild(activeIndicator);

    function updateIndicator(link) {
        const linkRect = link.getBoundingClientRect();
        const navRect = nav.getBoundingClientRect();
        
        activeIndicator.style.width = `${linkRect.width}px`;
        activeIndicator.style.left = `${linkRect.left - navRect.left}px`;
    }
    
    navLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            
            navLinks.forEach(l => l.classList.remove('active'));
            link.classList.add('active');
            
            updateIndicator(link);
            
            let tier = link.textContent.toLowerCase();
            currentTier = tier;
            leaderboardData = leaderboardDataSets[currentTier];
            renderLeaderboard(currentGangName);
        });
    });

    const activeLink = document.querySelector('nav a.active');
    if (activeLink) {
        updateIndicator(activeLink);
    }
}

function updateTitle(cupType) {
    const h1 = document.querySelector('h1');
    h1.innerHTML = cupType === 'premium' ? 'Diamond Gang<br/> <span class="premium">Premium</span> Cup' : 'Diamond<br/>Gang Cup';
}

document.addEventListener('DOMContentLoaded', () => {
    initializeNavigation();
    setTimeout(() => {
        $.post(`https://${GetParentResourceName()}/ready`, JSON.stringify({}));
    }, 100);

    window.addEventListener('message', (event) => {
        if (event.data.type === 'openLeaderboard') {
            leaderboardDataSets = event.data.data;
            currentGangName = event.data.currentGang;
            
            currentTier = findGangTier(leaderboardDataSets);
            
            const navLinks = document.querySelectorAll('nav a');
            navLinks.forEach(link => {
                if (link.textContent.toLowerCase() === currentTier) {
                    link.classList.add('active');
                    const nav = document.querySelector('nav');
                    const activeIndicator = nav.querySelector('.active-indicator');
                    const linkRect = link.getBoundingClientRect();
                    const navRect = nav.getBoundingClientRect();
                    activeIndicator.style.width = `${linkRect.width}px`;
                    activeIndicator.style.left = `${linkRect.left - navRect.left}px`;
                } else {
                    link.classList.remove('active');
                }
            });
            
            leaderboardData = leaderboardDataSets[currentTier];
            updateTitle(event.data.cupType);
            renderLeaderboard(currentGangName);
            setTimeout(() => {
                const leaderboard = document.querySelector('.leaderboard');
                leaderboard.classList.add('visible')
            }, 100);
        } else if (event.data.type === 'closeLeaderboard') {
            const leaderboard = document.querySelector('.leaderboard');
            leaderboard.classList.remove('visible');
        }
    });
});

document.addEventListener('keyup', function(event) {
    if (event.key === 'Escape') {
        const leaderboard = document.querySelector('.leaderboard');
        leaderboard.classList.remove('visible');
        $.post(`https://${GetParentResourceName()}/close`);
    }
});