import { doc, onSnapshot } from "firebase/firestore";
import { useEffect } from "react";
import { useAuthState } from "react-firebase-hooks/auth";
import { useRecoilState } from "recoil";
import { userState } from "../atoms/userAtom";
import { auth, firestore } from "../firebase/clientApp";
import nookies from "nookies";
import { User } from "firebase/auth";

const useAuth = () => {
  const [user] = useAuthState(auth);
  // const [currentUser, setCurrentUser] = useRecoilState(userState); maybe later

  useEffect(() => {
    console.log("HERE IS USER", user);

    user ? setUserCookie(user) : nookies.set(undefined, "token", "");
  }, [user]);

  const setUserCookie = async (user: User) => {
    const token = await user.getIdToken();
    console.log("HERE IS TOKEN", token);
    nookies.set(undefined, "token", token);
  };

  // useEffect(() => {
  //   // User has logged out; firebase auth state has been cleared
  //   if (!user?.uid && userState) {
  //     return setCurrentUser(null);
  //   }

  //   const userDoc = doc(firestore, "users", user?.uid as string);
  //   const unsubscribe = onSnapshot(userDoc, (doc) => {
  //     console.log("CURRENT DATA", doc.data());
  //     if (!doc.data()) return;
  //     if (currentUser) return;
  //     setCurrentUser(doc.data() as any);
  //   });

  //   if (currentUser) {
  //     unsubscribe();
  //   }

  //   return () => unsubscribe();
  // }, [user, currentUser]);
};
export default useAuth;
