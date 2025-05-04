const Config = {
    Theme: {
        Title: {
            Admin: "Ticket Manager",
            Player: "My Tickets"
        },
        Colors: {
            Background: "rgba(19, 22, 24, 0.9)",
            Text: "#ffffff"
        }
    },
    TicketConfiguration: {
        Categories: [
            "Tarh Shekaiat",
            "Darkhast Ozviat",
            "Sabt Gharardad",
            "Mavared Digar",
        ],
        Statuses: [
            {
                label: "Open",
                badgeType: "success",
                allowReplies: true
            },
            {
                label: "In Progress",
                badgeType: "warning",
                allowReplies: true
            },
            {
                label: "Closed",
                badgeType: "secondary",
                allowReplies: false
            },
        ],
        DefaultStatus: "Open",
        Disclaimer: "Lotfan ta 24 saat baraye residegi montazer bemanid."
    }
};

const state = {
    tickets: [],
    categories: [],
    statuses: [],
    disclaimer: false,
    isAdmin: false,
    debug: false,
    mediaUrls: [],
    currentLocation: null
};

function debugPrint(txt) {
    if (state.debug) {
        console.log(typeof txt == 'object' || Array.isArray(txt) ? JSON.stringify(txt) : txt);
    }
}

async function nuiRequest(path, data = {}) {
    if (typeof data == "string") {
        data = JSON.parse(decodeURIComponent(data));
    }
    
    return $.ajax({
        url: `https://${GetParentResourceName()}/${path}`,
        type: 'POST',
        dataType: 'json',
        data: JSON.stringify(data)
    });
}

function messageHandler(e) {
    if (!e.data.action) {
        return false;
    }

    if (handlers[e.data.action]) {
        return handlers[e.data.action](e.data);
    }
}

function showAlert(txt, type = "danger", elementId = 'alert') {
    const alert = $(`#${elementId}`);
    if (alert.length) {
        alert.hide()
            .removeClass('alert-danger alert-warning alert-success')
            .addClass(`alert-${type}`)
            .html(txt)
            .show();
    }
}

const handlers = {
    show: (data) => {
        setTheme({theme: Config.Theme});

        if (typeof data.admin !== 'undefined') {
            state.isAdmin = data.admin;
        }

        if (typeof data.debug !== 'undefined') {
            state.debug = data.debug;
        }

        state.categories = Config.TicketConfiguration.Categories;
        state.statuses = Config.TicketConfiguration.Statuses;
        state.disclaimer = Config.TicketConfiguration.Disclaimer;

        if (data.tickets) {
            handlers.tickets({ tickets: data.tickets });
        }

        state.currentLocation = data.location;

        setCategories();
        setDisclaimer();
        $('#modal').css({ display: 'flex' });
    },

    hide: () => {
        $('#modal').fadeOut();
    },

    tickets: (data) => {
        if (!data.tickets) return;
        
        state.tickets = data.tickets;
        const ticketsList = $('#tickets-list');
        ticketsList.html('');

        if (state.tickets.length === 0) {
            ticketsList.html('<tr><td colspan="5">No tickets to list at this time.</td></tr>');
            return;
        }

        state.tickets.forEach(item => {
            const status = item.status.toLowerCase();
            const statusData = state.statuses.find(s => s.label.toLowerCase() === status) || { badgeType: 'default' };
            
            ticketsList.append(`
                <tr>
                    <td>${item.id}</td>
                    <td><b>${item.title}</b></td>
                    <td>${item.category}</td>
                    <td><span class="badge text-bg-${statusData.badgeType}">${item.status.charAt(0).toUpperCase() + item.status.slice(1)}</span></td>
                    <td class="text-end">
                        <a href="javascript:void(0);" onclick="loadTicket(${item.id});" class="btn btn-primary">View</a>
                    </td>
                </tr>
            `);
        });
    }
};

$(document).ready(function() {
    $('.actionable').on('click', () => nuiRequest('hide'));
    $(document).on("keyup", (e) => { if (e.key === "Escape") nuiRequest('hide'); });

    $('#refresh-tickets').on('click', refreshTickets);
});

window.addEventListener('message', messageHandler);

window.loadTicket = loadTicket;
window.refreshTickets = refreshTickets;
window.addMediaItem = addMediaItem;

function setTheme(data) {
    if (data.theme) {
        if (data.theme.Title) {
            if (state.isAdmin) {
                $('.title-container > .title').html(data.theme.Title.Admin);
            } else {
                $('.title-container > .title').html(data.theme.Title.Player);
            }
        }

        if (data.theme.Colors.Background) {
            $('#modal .modal-content').css('background-color', data.theme.Colors.Background);
        }

        if (data.theme.Colors.Text) {
            $('body').css('color', data.theme.Colors.Text);
            $('.action').css('color', data.theme.Colors.Text);
        }
    }
}

function setCategories() {
    if (state.categories.length) {
        $('#category').html('');
        state.categories.forEach((category) => {
            $('#category').append(`<option value="${category}">${category}</option>`);
        });
    }
}

function setDisclaimer() {
    if (state.disclaimer !== false) {
        $('#disclaimer').html(`<div class="alert alert-info" role="alert">${state.disclaimer}</div>`);
    } else {
        $('#disclaimer').html('');
    }
}

function getStatusData(status) {
    return state.statuses.find(s => status.toLowerCase() === s.label.toLowerCase()) || false;
}

function handleReplies(replies) {
    $('#replies').html('');

    if (Array.isArray(replies) && replies.length) {
        replies.forEach((reply) => {
            $('#replies').append(
                `
                    <div class="card w-100 mt-3">
                        <div class="card-body">
                        <p class="card-text">${reply.name}: ${reply.message}</p>
                        </div>
                    </div>
                `
            );
        });
    }
}

async function loadTicket(id) {
    try {
        const res = await nuiRequest('ticket', { id, location: state.currentLocation });
        
        if (!res || !res.success) {
            showAlert('Unable to retrieve ticket information', 'error', 'main-alert');
            return;
        }

        const ticketId = $('#ticket-id');
        const ticketTitle = $('#ticket-title');
        const ticketMessage = $('#ticket-message');
        const ticketName = $('#ticket-name');

        ticketId.html('Ticket: #' + res.id);
        ticketTitle.html(res.title);
        ticketMessage.html(res.message);

        const mediaUrls = Array.isArray(res.media_urls) ? res.media_urls : 
                         (typeof res.media_urls === 'string' ? JSON.parse(res.media_urls) : []);

        if (mediaUrls && mediaUrls.length > 0) {
            const mediaContainer = $('<div class="ticket-media mt-3"><div class="media-preview"></div></div>');
            const mediaPreview = mediaContainer.find('.media-preview');

            for (const url of mediaUrls) {
                if (!url) continue;
                const result = await validateMediaUrl(url);
                if (result.valid) {
                    const mediaElement = result.type === 'video' ?
                        $(`<div class="media-item"><video controls><source src="${url}"></video></div>`) :
                        $(`<div class="media-item"><img src="${url}" alt="Media preview"></div>`);
                    mediaPreview.append(mediaElement);
                }
            }

            if (mediaPreview.children().length > 0) {
                ticketMessage.append(mediaContainer);
            }
        }

        if (state.isAdmin) {
            const buttonTicketStatus = $('#ticket-status');
            const buttonTicketStatuses = $('#ticket-statuses');

            buttonTicketStatus.html(res.status);
            buttonTicketStatuses.html('');
            state.statuses.forEach((status) => {
                buttonTicketStatuses.append(
                    `<li><a class="dropdown-item" href="javascript:void(0);" onclick="updateTicketStatus(${res.id}, '${status.label}');">${status.label}</a></li>`
                );
            });

            $('#ticket-status-container').show();
        } else {
            $('#ticket-status-container').hide();
        }

        $('#reply-submit').data('id', res.id);

        if (res.replies) {
            handleReplies(res.replies);
        }

        if (res.name) {
            ticketName.html(`Submitted by: ${res.name}`).show();
        } else {
            ticketName.html('').hide();
        }

        const statusData = getStatusData(res.status);
        if (statusData) {
            if (statusData.allowReplies === true) {
                $('#reply-form').show();
            } else {
                $('#reply-form').hide();
            }
        } else {
            $('#reply-form').hide();
        }

        if (state.isAdmin) {
            $('#ticket-actions').show();
            $('#close-ticket').data('id', res.id);
        } else {
            $('#ticket-actions').hide();
        }

        $('#form').hide();
        $('#view-ticket').show();
        $('#modal .modal-side').show();
    } catch (error) {
        console.error('Error loading ticket:', error);
        showAlert('Failed to load ticket information. ' + error.message, 'error', 'main-alert');
    }
}

async function reply(id, message) {
    if (!id) {
        return showAlert('There was an issue with replying. Please try again.', 'danger', 'view-alert');
    }

    if (!message) {
        return showAlert('You must provide a message in your reply.', 'danger', 'view-alert');
    }

    const res = await nuiRequest('reply', { ticket_id: id, message });

    if (!res.success) {
        return showAlert('There was an issue with replying. Please try again.', 'danger', 'view-alert');
    }

    $('#reply').val('');
    await loadTicket(id);
}

async function updateTicketStatus(id, status) {
    const res = await nuiRequest('status', { 
        id, 
        status,
        location: state.currentLocation
    });

    if (!res.success) {
        return showAlert('There was an issue updating the status. Please try again.', 'danger', 'view-alert');
    }

    await loadTicket(id);
}

function showDeleteConfirm(id) {
    $('#confirm-dialog').css('display', 'flex').fadeIn();
    $('#confirm-delete').data('ticketId', id);
}

function hideDeleteConfirm() {
    $('#confirm-dialog').fadeOut();
}

async function deleteTicket(id) {
    const res = await nuiRequest('delete', { 
        id, 
        location: state.currentLocation 
    });

    if (!res.success) {
        return showAlert('There was an issue deleting the ticket. Please try again.', 'danger', 'view-alert');
    }

    hideDeleteConfirm();
    $('#form').hide();
    $('#view-ticket').hide();
    $('#modal .modal-side').hide();
    $('#modal .modal-side').removeClass('show-side');

    nuiRequest('hide');
    
    await refreshTickets();
}

async function refreshTickets() {
    try {
        const res = await nuiRequest('refresh', { location: state.currentLocation });
        if (res.success) {
            showAlert("Tickets refreshed successfully", 'success', 'main-alert');
        }
        return res;
    } catch (error) {
        showAlert("Failed to refresh tickets", 'danger', 'main-alert');
        return { success: false };
    }
}

function resetForm() {
    $('#title').val('');
    $('#category').val('General');
    $('#message').val('');
    $('#media-items').html('');
    state.mediaUrls = [];
}

async function validateMediaUrl(url) {
    try {
        if (!url) return { valid: false, type: null };
        
        const mediaExtensions = {
            image: /\.(jpg|jpeg|png|gif)$/i,
            video: /\.(mp4)$/i
        };
        
        if (mediaExtensions.image.test(url)) {
            return { valid: true, type: 'image' };
        }
        if (mediaExtensions.video.test(url)) {
            return { valid: true, type: 'video' };
        }
        
        const timeout = 5000;
        const response = await fetch(url, {
            method: 'HEAD',
            cache: 'no-store',
            timeout,
            mode: 'no-cors'
        });
        
        const contentType = response.headers.get('content-type');
        if (!contentType) return { valid: false, type: null };
        
        if (contentType.includes('image')) {
            return { valid: true, type: 'image' };
        }
        if (contentType.includes('video')) {
            return { valid: true, type: 'video' };
        }
        
        return { valid: false, type: null };
    } catch (error) {
        try {
            if (mediaExtensions.image.test(url)) {
                return { valid: true, type: 'image' };
            }
            if (mediaExtensions.video.test(url)) {
                return { valid: true, type: 'video' };
            }
        } catch {
            return { valid: false, type: null };
        }
        return { valid: false, type: null };
    }
}

function addMediaItem() {
    const mediaId = Date.now();
    const mediaHtml = `
        <div class="media-item" data-id="${mediaId}">
            <div class="input-row">
                <input type="text" class="form-control" placeholder="Enter media URL (image or video)">
                <i class="fas fa-times remove-media"></i>
            </div>
            <div class="media-error">Invalid media URL</div>
            <div class="media-preview"></div>
        </div>
    `;
    $('#media-items').append(mediaHtml);

    const $mediaItem = $(`.media-item[data-id="${mediaId}"]`);
    const $input = $mediaItem.find('input');
    const $preview = $mediaItem.find('.media-preview');
    const $error = $mediaItem.find('.media-error');

    let debounceTimeout;
    $input.on('input', function() {
        clearTimeout(debounceTimeout);
        debounceTimeout = setTimeout(async () => {
            const url = $(this).val().trim();
            if (url) {
                const result = await validateMediaUrl(url);
                if (result.valid) {
                    if (result.type === 'video') {
                        $preview.html(`<video controls><source src="${url}"></video>`);
                    } else {
                        $preview.html(`<img src="${url}" alt="Media preview">`);
                    }
                    $preview.show();
                    $error.hide();
                    state.mediaUrls[mediaId] = url;
                } else {
                    $preview.hide();
                    $error.show();
                    delete state.mediaUrls[mediaId];
                }
            } else {
                $preview.hide();
                $error.hide();
                delete state.mediaUrls[mediaId];
            }
        }, 500);
    });

    $mediaItem.find('.remove-media').on('click', function() {
        delete state.mediaUrls[mediaId];
        $mediaItem.remove();
    });
}

function showMediaPreview(mediaElement) {
    const $modal = $('#media-preview-modal');
    const $container = $modal.find('.media-preview-container');
    const isVideo = mediaElement.tagName.toLowerCase() === 'video';
    
    if (isVideo) {
        const videoSrc = mediaElement.querySelector('source').src;
        $container.html(`<video controls autoplay><source src="${videoSrc}"></video>`);
    } else {
        const imgSrc = mediaElement.src;
        $container.html(`<img src="${imgSrc}" alt="Media preview">`);
    }
    
    $modal.css('display', 'flex').fadeIn();
}

function stopPreviewVideo() {
    const video = $('#media-preview-modal video').get(0);
    if (video) {
        video.pause();
        video.currentTime = 0;
    }
}

const mainNuiElement = '#modal';

$(document).ready(function () {
    $('.actionable').on('click', function () {
        nuiRequest('hide');
    });

    $(document).on("keyup", function(e) {
        if (e.key == "Escape") {
            nuiRequest('hide');
        }
    });

    $('#add-media').on('click', function() {
        addMediaItem();
    });

    $('#open-form').on('click', function (e) {
        e.preventDefault();
        $('#view-ticket').hide();
        $('#form').show();
        $('#modal .modal-side').show();
    });

    $('#close-form').on('click', function (e) {
        e.preventDefault();
        $('#modal .modal-side').hide();
        $('#view-ticket').hide();
        $('#form').hide();
    });

    $('#refresh-tickets').on('click', function (e) {
        e.preventDefault();
        $(this).addClass('rotating');
        refreshTickets().then(() => {
            setTimeout(() => {
                $(this).removeClass('rotating');
            }, 1000);
        });
    });

    $('#reply-submit').on('click', function () {
        const id = $(this).data('id');
        const message = $('#reply').val();
        reply(id, message);
    });

    $('#form').off('submit').on('submit', async function (e) {
        e.preventDefault();

        const title = $('#title').val();
        const category = $('#category').val();
        const message = $('#message').val();
        
        const mediaInputs = $('.media-item input');
        let hasInvalidMedia = false;
        
        mediaInputs.each(function() {
            const url = $(this).val().trim();
            if (url && !state.mediaUrls[$(this).closest('.media-item').data('id')]) {
                hasInvalidMedia = true;
                return false;
            }
        });

        if (hasInvalidMedia) {
            return showAlert("Please remove or fix invalid media URLs before submitting.");
        }

        const mediaUrls = Object.values(state.mediaUrls);

        if (!title) {
            return showAlert("The title is required.");
        }

        if (!category) {
            return showAlert("The category is required.");
        }

        if (!message) {
            return showAlert("The message is required.");
        }

        const data = {
            title,
            category,
            message,
            location: state.currentLocation, 
            media_urls: mediaUrls
        };

        const res = await nuiRequest('create', data);

        if (!res.success) {
            if (res.error) {
                return showAlert(res.error);
            } else {
                return showAlert("Unable to create ticket. Please try again");
            }
        }

        $('#form').hide();
        $('#modal .modal-side').hide();
        resetForm();

        return showAlert("Ticket was created successfully", 'success', 'main-alert');
    });

    $('#close-ticket').on('click', function () {
        const id = $(this).data('id');
        showDeleteConfirm(id);
    });

    $('#confirm-delete').on('click', function() {
        const id = $(this).data('ticketId');
        deleteTicket(id);
    });

    $('#cancel-delete').on('click', function() {
        hideDeleteConfirm();
    });

    $('#confirm-dialog').on('click', function(e) {
        if (e.target === this) {
            hideDeleteConfirm();
        }
    });

    $(document).on('click', '.media-preview img, .media-preview video', function(e) {
        e.stopPropagation();
        showMediaPreview(this);
    });

    $('#media-preview-modal, .media-preview-close').on('click', function(e) {
        if (e.target === this || $(this).hasClass('media-preview-close')) {
            stopPreviewVideo();
            $('#media-preview-modal').fadeOut();
        }
    });

    $('.media-preview-container').on('click', function(e) {
        e.stopPropagation();
    });
});

window.addEventListener('message', function(event){
    messageHandler(event);
});