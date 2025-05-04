document.addEventListener('DOMContentLoaded', function () {
    const reportModal = document.getElementById('reportModal');
    const closeModalBtn = document.getElementById('closeModalBtn');
    const reportForm = document.getElementById('reportForm');
    const kill = document.getElementById('kill');
    const thankYouMessage = document.getElementById('thankYouMessage');
    const reason = document.getElementById('reportReason');
    const reptype= document.getElementById('reportType');

    const selectBtn = document.querySelector(".select-btn"),
        items = document.querySelectorAll(".item");

    selectBtn.addEventListener("click", () => {
        selectBtn.classList.toggle("open");
    });

    // remove class open when click to other side 
    document.addEventListener("click", (e) => {
        if (e.target.closest(".select-btn")) return;
        if (e.target.closest(".list-items")) return;


        selectBtn.classList.remove("open");
    });

    let reasonsValue = []
    items.forEach(item => {
        item.addEventListener("click", () => {
            item.classList.toggle("checked");
            let checked = document.querySelectorAll(".checked"),
                btnText = document.querySelector(".btn-text");


            reasonsValue = []
            checked.forEach((item) => {
                reasonsValue.push(item.innerText)
            })

            if (checked && checked.length > 0) {
                btnText.innerText = `${checked.length} Selected`;
            } else {
                btnText.innerText = "Select Multiple Reasons";
            }
        });
    })


    closeModalBtn.addEventListener('click', function () {
        reportModal.style.display = 'none';
        CloseUI()
    });

    window.addEventListener('message', (event) => {
        if (event.data.toggle == true) {
            reportModal.style.display = 'flex';
            reason.value = ""
            reptype.value = ""
            if (event.data.data !== undefined){
                kill.style.display = 'flex';
                document.getElementById("killData").value = "ID: "+event.data.data.id;
            }
        }
        if (event.data.toggle == false) {
            reportModal.style.display = 'none';
            kill.style.display = 'none';
        }
    });

    reportForm.addEventListener('submit', function (event) {
        event.preventDefault();
        let res = document.getElementById('reportReason');
        let rep = document.getElementById('reportType');
        let ref = reasonsValue
        fetch(`https://esx_creport/registerReport`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                ID: rep.value,
                Res: res.value,
                ref: reasonsValue
            })
        })
    });

    function CloseUI(){
        fetch(`https://esx_creport/exit`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
        })
        kill.style.display = 'none';
    }
});