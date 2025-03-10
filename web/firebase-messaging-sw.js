importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

const firebaseConfig = {
  apiKey: "AIzaSyD_I4chkDLyOHzPIusjGThTegpIXJjTNJE",
  authDomain: "tucomercio-a4667.firebaseapp.com",
  projectId: "tucomercio-a4667",
  storageBucket: "tucomercio-a4667.firebasestorage.app",
  messagingSenderId: "944409408863",
  appId: "1:944409408863:web:b80b74969f67d56ee732ea",
  measurementId: "G-G-PKXVQ024QC",
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
    console.log('📩 Notificación en segundo plano:', payload);
    const notificationTitle = payload.notification?.title || "Nueva Notificación";
    const notificationOptions = {
        body: payload.notification?.body || "Tienes una nueva notificación.",
        icon: '/icons/Icon-192.png',
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});
