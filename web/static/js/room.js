const RoomSlug = document.getElementById("roomSlug").value;
const myUser = document.getElementById("myUser").value;

let Room = {
    init(socket){
        socket.connect();
        this.onReady(socket);
    },

    onReady(socket){
        let submitBtn = document.getElementById("submitBtn");
        let msgContainer = document.getElementById("messageContainer");
        let msgInput = document.getElementById("messageInput");
        let roomChannel = socket.channel("room:"+RoomSlug);

        submitBtn.addEventListener("click", e => {
            let payload = { content: msgInput.value}
            roomChannel.push("new chat", payload)
                .receive("error", e => console.log(e))
            msgInput.value = "";
        });

        roomChannel.on("new chat", (resp) => {
            this.rendermsg(msgContainer, resp)
        })

        roomChannel.join()
            .receive("ok", resp => console.log("Joined room channel ", resp))
            .receive("error", resp => console.log("Failed to join room channel ", resp))
    },

    esc(str){
        let div = document.createElement("div");
        div.appendChild(document.createTextNode(str));
        return div.innerHTML;
    },

    rendermsg(container, {user, body, at}){
        let template = document.createElement('div');
        if(user != myUser)
            template.className = 'rounded font-w600 p-10 mb-10 animated fadeIn mr-50 bg-body-light';
        else
            template.className = 'rounded font-w600 p-10 mb-10 animated fadeIn ml-50 bg-body-light';
        template.innerHTML = body;
        container.appendChild(template);
        container.scrollTop = container.scrollHeight;
    }
}

export default Room;