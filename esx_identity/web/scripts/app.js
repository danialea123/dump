let MinNameLength = 3;
let MaxNameLength = 20;
let minBrithDay = 1950;
let maxBrithDay = 2018;
let MinHeight = 120;
let MaxHeight = 220;

let badWords = [];
let page = "";
let ActiveStatus = null;
let reward_ui_image = "";
let swiper;
let locale_id = "YOUR ID";
let locale_invite = "YOUR INVITES";
let locale_claim = "CLAIM REWARD";

$(function () {
    $.post(`https://${GetParentResourceName()}/ready`, JSON.stringify({}));
    // $("#datepicker").dateDropper({
    //     maxYear: maxBrithDay,
    //     minYear: minBrithDay,
    //     startFromMonday: false,
    //     large: false,
    //     largeDefault: false,
    //     theme: "picker1",
    // });
    $("#datepicker").on("change", (e) => {
        if (
            $("#datepicker").val().split("/")[2] > maxBrithDay ||
            $("#datepicker").val().split("/")[2] < minBrithDay
        ) {
            e.target.value = "";
        } else {
        }
    });
    $(".gender-item").on("click", function () {
        $(".gender-item").toggleClass("active");
    });

    function validateFirstName() {
        var firstName = $("#first-name").val();
        if (
            /^[A-Za-z]{3,}$/.test(firstName) &&
            !badWords.includes(firstName) &&
            firstName.length < 12
        ) {
            $("#first-name")
                .css("border", "2px solid #46c179")
                .siblings(".state")
                .removeClass("error")
                .addClass("accept")
                .html(`<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                <path d="M9 22H15C20 22 22 20 22 15V9C22 4 20 2 15 2H9C4 2 2 4 2 9V15C2 20 4 22 9 22Z"
                    stroke="#59FF9C" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                <path d="M7.75 11.9999L10.58 14.8299L16.25 9.16992" stroke="#59FF9C" stroke-width="1.5"
                    stroke-linecap="round" stroke-linejoin="round" />
            </svg>`);
        } else {
            $("#first-name")
                .css("border", "2px solid #e04f50")
                .siblings(".state")
                .removeClass("accept")
                .addClass("error")
                .html(
                    `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M9.16992 14.8299L14.8299 9.16992" stroke="#FF5959" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M14.8299 14.8299L9.16992 9.16992" stroke="#FF5959" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M9 22H15C20 22 22 20 22 15V9C22 4 20 2 15 2H9C4 2 2 4 2 9V15C2 20 4 22 9 22Z" stroke="#FF5959" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>`
                );
        }
    }

    function validateHeight() {
        var height = $("#height").val();
        var numericHeight = parseInt(height, 10); // Convert height to a numeric value
        if (numericHeight >= MinHeight && numericHeight <= MaxHeight) {
            $("#height")
                .css("border", "2px solid #46c179")

                .siblings(".state")
                .removeClass("error")
                .addClass("accept")
                .html(`<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                <path d="M9 22H15C20 22 22 20 22 15V9C22 4 20 2 15 2H9C4 2 2 4 2 9V15C2 20 4 22 9 22Z"
                    stroke="#59FF9C" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                <path d="M7.75 11.9999L10.58 14.8299L16.25 9.16992" stroke="#59FF9C" stroke-width="1.5"
                    stroke-linecap="round" stroke-linejoin="round" />
            </svg>`);
        } else {
            $("#height")
                .css("border", "2px solid #e04f50")

                .siblings(".state")
                .removeClass("accept")
                .addClass("error")
                .html(
                    `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                <path d="M9.16992 14.8299L14.8299 9.16992" stroke="#FF5959" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M14.8299 14.8299L9.16992 9.16992" stroke="#FF5959" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M9 22H15C20 22 22 20 22 15V9C22 4 20 2 15 2H9C4 2 2 4 2 9V15C2 20 4 22 9 22Z" stroke="#FF5959" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>`
                );
        }
    }

    function validateLastName() {
        var lastname = $("#last-name").val();
        if (
            /^[A-Za-z]{3,}$/.test(lastname) &&
            !badWords.includes(lastname) &&
            lastname.length < 12
        ) {
            $("#last-name")
                .css("border", "2px solid #46c179")
                .siblings(".state")
                .removeClass("error")
                .addClass("accept")
                .html(`<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                <path d="M9 22H15C20 22 22 20 22 15V9C22 4 20 2 15 2H9C4 2 2 4 2 9V15C2 20 4 22 9 22Z"
                    stroke="#59FF9C" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                <path d="M7.75 11.9999L10.58 14.8299L16.25 9.16992" stroke="#59FF9C" stroke-width="1.5"
                    stroke-linecap="round" stroke-linejoin="round" />
            </svg>`);
        } else {
            $("#last-name")
                .css("border", "2px solid #e04f50")
                .siblings(".state")
                .removeClass("accept")
                .addClass("error")
                .html(
                    `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M9.16992 14.8299L14.8299 9.16992" stroke="#FF5959" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M14.8299 14.8299L9.16992 9.16992" stroke="#FF5959" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M9 22H15C20 22 22 20 22 15V9C22 4 20 2 15 2H9C4 2 2 4 2 9V15C2 20 4 22 9 22Z" stroke="#FF5959" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>`
                );
        }
    }

    function validateBirthday() {
        var birthday = $("#datepicker").val();
        if (birthday !== "") {
            $("#datepicker")
                .css("border", "2px solid #46c179")
                .siblings(".state")
                .removeClass("error")
                .addClass("accept")
                .html(`<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                <path d="M9 22H15C20 22 22 20 22 15V9C22 4 20 2 15 2H9C4 2 2 4 2 9V15C2 20 4 22 9 22Z"
                    stroke="#59FF9C" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                <path d="M7.75 11.9999L10.58 14.8299L16.25 9.16992" stroke="#59FF9C" stroke-width="1.5"
                    stroke-linecap="round" stroke-linejoin="round" />
            </svg>`);
        } else {
            $("#datepicker")
                .css("border", "2px solid #e04f50")
                .siblings(".state")
                .removeClass("accept")
                .addClass("error")
                .html(
                    `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M9.16992 14.8299L14.8299 9.16992" stroke="#FF5959" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M14.8299 14.8299L9.16992 9.16992" stroke="#FF5959" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M9 22H15C20 22 22 20 22 15V9C22 4 20 2 15 2H9C4 2 2 4 2 9V15C2 20 4 22 9 22Z" stroke="#FF5959" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>`
                );
        }
    }

    $("#register").on("click", function () {
        console.log("testRegister");
        validateFirstName();
        validateLastName();
        validateHeight();
        validateBirthday();

        // Check if all inputs are not empty and have no errors
        if (
            !$(".state").hasClass("error") &&
            $("#first-name").val() !== "" &&
            $("#last-name").val() !== "" &&
            $("#height").val() !== "" &&
            $("#datepicker").val() !== ""
        ) {
            $(".loader-div").show();
            // Add a spinner before </body> tag

            // Delay for 4 seconds (4000 milliseconds)
            setTimeout(function () {
                // Remove the spinner after the delay
                var selectedGender = $(".gender-item.active").attr("id");
                $.post(
                    `https://${GetParentResourceName()}/register`,
                    JSON.stringify({
                        firstname: $("#first-name").val(),
                        lastname: $("#last-name").val(),
                        dateofbirth: $("#datepicker").val(),
                        sex: selectedGender,
                        height: $("#height").val(),
                    })
                );
                console.log(selectedGender);
                $(".loader-div").hide();
            }, 3000);
        }
    });

    // Add event listeners for input changes
    $("#first-name").on("input propertychange", validateFirstName);
    $("#last-name").on("input propertychange", validateLastName);
    $("#height").on("input propertychange", validateHeight);
    $("#datepicker").on("input propertychange", validateBirthday);
});

const copyToClipboard = (str) => {
    const el = document.createElement("textarea");
    el.value = str;
    document.body.appendChild(el);
    el.select();
    document.execCommand("copy");
    document.body.removeChild(el);
};

$("a").on("click", (e) => {
    e.preventDefault();
    window.invokeNative("openUrl", $(e.target).closest("a").attr("href"));
});

$(".user-code").on("click", (e) => {
    Toastify({
        text: `✔ Copied To Clipboard`,
        duration: 3000,
        gravity: "bottom", // `top` or `bottom`
        position: "center", // `left`, `center` or `right`
        style: {
            background: "#05020977",
            borderRadius: "10px",
            boxShadow: "none",
        },
        onClick: function () {}, // Callback after click
    }).showToast();
    // COPY TO CLIP BOARD
    copyToClipboard($(e.target).text());
});

$(".apply").on("click", (e) => {
    ref = $("#referral").val();
    $(".apply").attr("disabled", true);
    $(".apply").html(`<i class="fa-solid loading fa-rotate"></i>`);
    $.post(
        `https://${GetParentResourceName()}/checkref`,
        JSON.stringify({ ref })
    ).then((data) => {
        if (data.status) {
            $(".apply").html(`<i class="fa-solid fa-check"></i> `);
        } else {
            $(".apply").html(`<i class="fa-solid fa-xmark"></i> `);
            $(".apply").attr("disabled", false);
            setTimeout(() => {
                $(".apply").text("Apply");
            }, 3000);
        }
    });
});

window.addEventListener("keydown", (e) => {
    if (["Escape"].includes(e.code)) {
        if (page !== "register")
            $.post(
                `https://${GetParentResourceName()}/hideFrame`,
                JSON.stringify({})
            );
    }
});

window.addEventListener("message", (event) => {
    switch (event.data.action) {
        case "show_register":
            page = "register";
            $(".register-form").show();
            break;
        case "show_reward":
            if (swiper) {
                swiper.destroy(true, true);
            }
            $("#reward-items").empty();
            const reward_detail = event.data.data;
            reward_detail.forEach((item) => {
                createReward(
                    reward_ui_image,
                    item.code,
                    item.inviteCount,
                    item.rewardImage,
                    item.id,
                    item.rewardReady,
                    item.title
                );
            });
            swiper = new Swiper(".swiper", {
                // Optional parameters
                direction: "horizontal",
                slidesPerView: 1,
                effect: "cards",
                grabCursor: true,
            });
            // Send The Item Id to User

            ActiveStatus = reward_detail.rewardReady;
            $(".claim").on("click", (e) => {
                $.post(
                    `https://${GetParentResourceName()}/claim`,
                    JSON.stringify({
                        active: ActiveStatus,
                        id: $(e.target).attr("data-id"),
                    })
                );
            });
            $("#reward-code").on("click", (e) => {
                copyToClipboard($(e.target).text());
                Toastify({
                    text: `✔ Copied To Clipboard`,
                    duration: 3000,
                    gravity: "bottom", // `top` or `bottom`
                    position: "center", // `left`, `center` or `right`
                    style: {
                        background: "#05020977",
                        borderRadius: "10px",
                        boxShadow: "none",
                    },
                    onClick: function () {}, // Callback after click
                }).showToast();
            });
            page = "reward";
            $(".reward").show();
            break;
        case "hide_register":
            $(".register-form").hide();
            break;
        case "show_tutorial":
            $(".tutorial .title").text(event.data.title);
            $(".tutorial .description").text(event.data.description);
            $(".tutorial").toggleClass("hide_tutorial");
            break;
        case "hide_tutorial":
            $(".tutorial .title").text(event.data.title);
            $(".tutorial .description").text(event.data.description);
            $(".tutorial").toggleClass("hide_tutorial");
            break;
        case "hide_reward":
            $(".reward").hide();
            break;
        case "show_notif":
            Toastify({
                text: event.data.data.text,
                duration: event.data.data.time,
                gravity: "bottom", // `top` or `bottom`
                position: "center", // `left`, `center` or `right`
                style: {
                    background: "#05020977",
                    borderRadius: "10px",
                    boxShadow: "none",
                },
                onClick: function () {}, // Callback after click
            }).showToast();
            break;
        case "setConfig":
            const data = event.data;
            document.body.style.setProperty("--color", data.Config.theme.color);
            document.body.style.setProperty(
                "--gradient",
                data.Config.theme.gradient
            );
            $("#background-register").attr("src", data.Config.theme.image);
            // $("#reward-image").attr("src", data.Config.theme.reward_image);
            reward_ui_image = data.Config.theme.reward_image;
            $("#logo img").attr("src", data.Config.logo);
            $("#instagram").attr("href", data.Config.socials.instagram);
            $("#discord").attr("href", data.Config.socials.discord);
            $("#website").attr("href", data.Config.socials.website);
            $(".user-code").text(data.Config.userRefCode);
            badWords = event.data.Config.badNames;
            MinNameLength = event.data.Config.MinNameLength;
            MaxNameLength = event.data.Config.MaxNameLength;
            minBrithDay = event.data.Config.minBrithDay;
            maxBrithDay = event.data.Config.maxBrithDay;
            MinHeight = event.data.Config.MinHeight;
            MaxHeight = event.data.Config.MaxHeight;
            $("#datepicker").dateDropper({
                maxYear: maxBrithDay,
                minYear: minBrithDay,
                startFromMonday: false,
                large: false,
                largeDefault: false,
                theme: "picker2",
            });

            const locale = event.data.Config.locale;
            $(".locale-register").text(locale.register);
            $(".locale-firstname").text(locale.firstname);
            $(".locale-lastname").text(locale.lastname);
            $(".locale-birthday").text(locale.birthday);
            $(".locale-height").text(locale.height);
            $(".locale-apply").text(locale.apply);
            $(".locale-referral").text(locale.referral);
            $(".locale-create").text(locale.create);
            locale_id = locale.id;
            locale_invite = locale.invite;
            locale_claim = locale.claim;

            break;
        default:
            console.log("unknow!");
            break;
    }
});

const createReward = (
    image,
    code,
    invitecount,
    reward_image,
    id,
    ready,
    reward_title
) => {
    $("#reward-items").append(
        `<div class="swiper-slide reward ">
    <img id="reward-image" src="${image}">
    <div class="reward-detail">
        <div class="icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="17" height="16" viewBox="0 0 17 16" fill="none">
                <path
                    d="M8.63673 1.75C6.92974 1.75 5.54199 3.08125 5.54199 4.71875C5.54199 6.325 6.85155 7.625 8.55855 7.68125C8.61067 7.675 8.66279 7.675 8.70188 7.68125C8.71491 7.68125 8.72143 7.68125 8.73446 7.68125C8.74097 7.68125 8.74097 7.68125 8.74749 7.68125C10.4154 7.625 11.725 6.325 11.7315 4.71875C11.7315 3.08125 10.3437 1.75 8.63673 1.75Z"
                    fill="white" />
                <path
                    d="M11.9463 9.34355C10.1285 8.18105 7.16409 8.18105 5.33331 9.34355C4.50587 9.8748 4.0498 10.5936 4.0498 11.3623C4.0498 12.1311 4.50587 12.8436 5.32679 13.3686C6.23892 13.9561 7.43773 14.2498 8.63653 14.2498C9.83533 14.2498 11.0341 13.9561 11.9463 13.3686C12.7672 12.8373 13.2233 12.1248 13.2233 11.3498C13.2167 10.5811 12.7672 9.86855 11.9463 9.34355Z"
                    fill="white" />
            </svg>
        </div>
        <div class="title ">
            <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 13 13" fill="none">
                <path
                    d="M6.37668 0.833496L8.67627 4.45662L12.7534 6.50016L8.67627 8.5437L6.37668 12.1668L4.07709 8.5437L0 6.50016L4.07709 4.45662L6.37668 0.833496Z" />
            </svg>
            ${locale_id}
        </div>
        <div class="content" id="reward-code">${code}</div>

    </div>
    <div class="reward-detail">
        <div class="icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32" fill="none">
                <g clip-path="url(#clip0_248_728)">
                    <path
                        d="M10.6666 14.3468H9.89324C8.83792 14.3087 7.78601 14.4878 6.8028 14.8732C5.8196 15.2585 4.92608 15.8418 4.17769 16.5868L3.96436 16.8357V24.1957H7.59102V20.0179L8.07991 19.4668L8.30213 19.209C9.4594 18.0202 10.9002 17.1453 12.4888 16.6668C11.6934 16.0616 11.0661 15.2629 10.6666 14.3468Z"
                        fill="white" />
                    <path
                        d="M27.8577 16.56C27.1093 15.8149 26.2158 15.2316 25.2326 14.8463C24.2494 14.461 23.1975 14.2818 22.1422 14.32C21.8185 14.3209 21.4951 14.3387 21.1733 14.3733C20.7663 15.2328 20.1561 15.9802 19.3955 16.5511C21.0915 17.0203 22.6278 17.9421 23.84 19.2177L24.0622 19.4666L24.5422 20.0177V24.2044H28.0444V16.8089L27.8577 16.56Z"
                        fill="white" />
                    <path
                        d="M9.86664 12.6135H10.1422C10.0142 11.5141 10.2071 10.4012 10.6976 9.40912C11.1881 8.417 11.9554 7.58806 12.9066 7.02237C12.5618 6.49557 12.0861 6.06736 11.526 5.77966C10.966 5.49196 10.3408 5.35464 9.71173 5.38115C9.08267 5.40766 8.47127 5.59709 7.93741 5.93089C7.40355 6.26468 6.96553 6.73141 6.66624 7.28535C6.36695 7.8393 6.21666 8.46147 6.23007 9.09095C6.24349 9.72044 6.42016 10.3356 6.74277 10.8763C7.06539 11.417 7.5229 11.8647 8.0705 12.1754C8.6181 12.4862 9.23701 12.6494 9.86664 12.649V12.6135Z"
                        fill="white" />
                    <path
                        d="M21.7156 11.9466C21.7264 12.1509 21.7264 12.3556 21.7156 12.5599C21.8862 12.5869 22.0585 12.6018 22.2311 12.6043H22.4C23.0269 12.5709 23.6344 12.3757 24.1634 12.0378C24.6925 11.6999 25.125 11.2308 25.4189 10.6761C25.7128 10.1214 25.8581 9.50004 25.8406 8.87254C25.8231 8.24504 25.6434 7.63276 25.319 7.09532C24.9946 6.55787 24.5366 6.11358 23.9896 5.80569C23.4425 5.4978 22.825 5.33681 22.1973 5.33839C21.5696 5.33997 20.9529 5.50407 20.4074 5.8147C19.8619 6.12534 19.4061 6.57193 19.0845 7.111C19.889 7.63627 20.5505 8.35305 21.0098 9.19702C21.469 10.041 21.7115 10.9857 21.7156 11.9466Z"
                        fill="white" />
                    <path
                        d="M15.8845 15.9291C18.0789 15.9291 19.8578 14.1502 19.8578 11.9558C19.8578 9.76134 18.0789 7.98242 15.8845 7.98242C13.6901 7.98242 11.9111 9.76134 11.9111 11.9558C11.9111 14.1502 13.6901 15.9291 15.8845 15.9291Z"
                        fill="white" />
                    <path
                        d="M16.0979 18.0446C14.937 17.9977 13.7787 18.1862 12.6926 18.5986C11.6065 19.0111 10.615 19.639 9.77789 20.4446L9.55566 20.6935V26.3201C9.55913 26.5034 9.59867 26.6842 9.67203 26.8522C9.74539 27.0202 9.85112 27.1721 9.9832 27.2992C10.1153 27.4263 10.2711 27.5262 10.4418 27.5931C10.6124 27.66 10.7946 27.6926 10.9779 27.689H21.1912C21.3745 27.6926 21.5567 27.66 21.7273 27.5931C21.898 27.5262 22.0538 27.4263 22.1859 27.2992C22.318 27.1721 22.4237 27.0202 22.4971 26.8522C22.5704 26.6842 22.61 26.5034 22.6134 26.3201V20.7113L22.4001 20.4446C21.5684 19.6365 20.5804 19.0068 19.4967 18.5941C18.413 18.1814 17.2564 17.9944 16.0979 18.0446Z"
                        fill="white" />
                </g>
                <defs>
                    <clipPath id="clip0_248_728">
                        <rect width="32" height="32" fill="white" />
                    </clipPath>
                </defs>
            </svg>
        </div>
        <div class="title">
            <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 13 13" fill="none">
                <path
                    d="M6.37668 0.833496L8.67627 4.45662L12.7534 6.50016L8.67627 8.5437L6.37668 12.1668L4.07709 8.5437L0 6.50016L4.07709 4.45662L6.37668 0.833496Z" />
            </svg>
            YOUR INVITES
        </div>
        <div class="content" id="reward-invitecount">${invitecount}</div>
    </div>
    <div class="reward-detail item">
        <div class="title">
            <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 13 13" fill="none">
                <path
                    d="M6.37668 0.833496L8.67627 4.45662L12.7534 6.50016L8.67627 8.5437L6.37668 12.1668L4.07709 8.5437L0 6.50016L4.07709 4.45662L6.37668 0.833496Z" />
            </svg>
            YOUR INVITES
        </div>
        <div class="content reward-img">
            <img id="reward-item-image"  src="${reward_image}" alt="">
            <h1>${reward_title}</h1>
        </div>
    </div>
    <button class="claim" data-id="${id}"  id="reward-claim">CLAIM REWARD</button>
</div>`
    );
};
