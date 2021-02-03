/**
 * Append messages to the list
 */
function appendMessages(...messages) {
    for (const message of messages) {
        const element = document.createElement('p');
        if (message.fromDio) {
            element.classList.add('dio');
        }
    
        element.innerText = message.message;
    
        document.querySelector('#messages').appendChild(element);
    }
    
    const container = document.querySelector('#messages');
    container.scrollTo(0, container.scrollHeight);
}

/**
 * Send message when form is submitted
 */
document.querySelector('form').onsubmit = (event) => {
    event.preventDefault();

    const input = document.querySelector('input[type="text"]');
    const message = {
        userId: localStorage.getItem('userId'),
        message: input.value
    };

    appendMessages(message);

    input.value = '';

    fetch('/message', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(message)
    })
    .then(response => response.json())
    .then(({ reply }) => appendMessages(reply));
};


const recoverMessages = () => {
    fetch('/hey', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            userId: localStorage.getItem('userId')
        })
    })
    .then(response => response.json())
    .then(({ userId, history }) => {
        localStorage.setItem('userId', userId);
        appendMessages(...history);
    });
}

/**
 * When page is loaded, recover old messages from MongoDb
 */
window.addEventListener('load', () => recoverMessages());
