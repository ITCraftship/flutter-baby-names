import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import { DocumentSnapshot } from "firebase-functions/lib/providers/firestore";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

admin.initializeApp();
const db = admin.firestore();

const handleVoteUpdate = async (
  newName: DocumentSnapshot,
  increment: number
) => {
  console.log(`Updating votes on ${newName.id}`);
  // if we add context parameter, then we can get context.params.name
  const name = newName.id;
  const baby = await db.collection("baby").doc(name).get();
  if (baby.exists) {
    await baby.ref.update({
      votes: admin.firestore.FieldValue.increment(increment),
    });
  } else {
    await baby.ref.set({
      name: `${name[0].toUpperCase()}${name.substring(1)}`,
      votes: admin.firestore.FieldValue.increment(increment),
    });
  }
};

export const addVote = functions.firestore
  .document("/votes/{userId}/names/{name}")
  .onCreate((newName) => handleVoteUpdate(newName, 1));

export const deleteVote = functions.firestore
  .document("/votes/{userId}/names/{name}")
  .onDelete((newName) => handleVoteUpdate(newName, -1));
