import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

export const createUserDocument = functions.auth
  .user()
  .onCreate(async (user) => {
    db.collection("users")
      .doc(user.uid)
      .set(JSON.parse(JSON.stringify(user)));
  });

export const deletePostComments = functions.firestore
  .document(`posts/{postId}`)
  .onDelete(async (snap) => {
    const postId = snap.id;
    console.log("HERE IS POST ID", postId);

    admin
      .firestore()
      .collection("comments")
      .get()
      .then((snapshot) => {
        snapshot.forEach((doc) => {
          if (doc.data().postId === postId) {
            console.log("DELETING COMMENT: ", doc.id, doc.data().text);
            doc.ref.delete();
          }
        });
      })
      .catch((error) => {
        console.log("Error deleting post comments");
      });
  });
