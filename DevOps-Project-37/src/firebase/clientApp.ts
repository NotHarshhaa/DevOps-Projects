import { initializeApp, getApp, getApps } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getStorage } from "firebase/storage";

// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBqe95nCUomWkU9PnZT_OlV_NCAZnTmyz0",
  authDomain: "reddit-clone-r.firebaseapp.com",
  projectId: "reddit-clone-r",
  storageBucket: "reddit-clone-r.appspot.com",
  messagingSenderId: "233455437474",
  appId: "1:233455437474:web:5f21ac4b94a42fddb379fb",
  measurementId: "G-3L9HMZR4XQ"
};
// Initialize Firebase for SSR
const app = !getApps().length ? initializeApp(firebaseConfig) : getApp();
const firestore = getFirestore(app);
const auth = getAuth(app);
const storage = getStorage(app);

export { app, auth, firestore, storage };
