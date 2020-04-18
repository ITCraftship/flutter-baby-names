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

const handleVoteUpdate = async (newName: DocumentSnapshot) => {
  // if we add context parameter, then we can get context.params.name
  const name = newName.id;
  const babyRef = db.collection("baby").doc(name);
  await db.runTransaction(async (transaction) => {
    const baby = await transaction.get(babyRef);
    let newVotes = 0;
    const oldData = baby.data() || {
      name: `${name[0].toUpperCase()}${name.substring(1)}`,
    };

    if (baby.exists && oldData) {
      newVotes = oldData.votes + 1;
    }

    return transaction.set(babyRef, { ...oldData, votes: newVotes });
  });
};

export const addVote = functions.firestore
  .document("/votes/{userId}/names/{name}")
  .onCreate(handleVoteUpdate);

export const deleteVote = functions.firestore
  .document("/votes/{userId}/names/{name}")
  .onDelete(async (change, context) => {
    console.log("Doing nothing now");
  });
