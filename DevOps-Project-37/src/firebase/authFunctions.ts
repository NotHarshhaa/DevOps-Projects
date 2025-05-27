import { GoogleAuthProvider, signInWithPopup, signOut } from "firebase/auth";

import { auth } from "./clientApp";

export const signInWithGoogle: any = async () =>
  signInWithPopup(auth, new GoogleAuthProvider());

export const signUpWithEmailAndPassword = async (
  email: string,
  password: string
) => {};

export const loginWithEmaiAndPassword = async (
  email: string,
  password: string
) => {};

export const logout = () => signOut(auth);
