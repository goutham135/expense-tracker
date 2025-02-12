const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

/**
 * Sends daily expense reminders to users who haven't logged
 * expenses in the past 3 days. This function is scheduled to
 * run daily at 9:00 AM UTC.
 * @param {functions.Context} context The Firebase Cloud
 *   Functions context.
 * @return {Promise<null>} A promise that resolves to null.
 */
exports.sendExpenseReminders = functions.pubsub.schedule(
    "0 9 * * *",
).onRun(async (context) => {
  try {
    const db = admin.firestore();
    const usersCollection = db.collection("users");

    const now = new Date();
    const threeDaysAgo = new Date(
        now.getTime() - 3 * 24 * 60 * 60 * 1000,
    );

    const usersSnapshot = await usersCollection.get();

    for (const userDoc of usersSnapshot.docs) {
      const userData = userDoc.data();
      const userId = userDoc.id;

      const expensesCollection = db.collection(`users/${userId}/expenses`);
      const lastExpenseSnapshot = await expensesCollection
          .orderBy("timestamp", "desc")
          .limit(1)
          .get();

      if (lastExpenseSnapshot.empty) {
        await sendNotification(
            userId,
            userData.fcmToken,
            "Reminder: Log your expenses!",
            "You haven't logged any expenses yet. Keep track " +
              "of your spending!",
        );
      } else {
        const lastExpenseData = lastExpenseSnapshot.docs[0].data();
        const lastExpenseTimestamp = lastExpenseData.timestamp.toDate();

        if (lastExpenseTimestamp < threeDaysAgo) {
          await sendNotification(
              userId,
              userData.fcmToken,
              "Reminder: Log your expenses!",
              "It's been a few days since you logged your " +
                "expenses. Update your spending!",
          );
        }
      }
    }

    return null;
  } catch (error) {
    console.error("Error sending reminders:", error);
    return null;
  }
});

/**
 * Sends a Firebase Cloud Message (FCM) notification to a user.
 * @param {string} userId The ID of the user receiving the
 *   notification.
 * @param {string} fcmToken The user's FCM token.
 * @param {string} title The notification title.
 * @param {string} body The notification body.
 * @return {Promise<void>} A promise that resolves when the
 *   notification is sent or an error occurs.
 */
async function sendNotification(userId, fcmToken, title, body) {
  if (!fcmToken) {
    console.log(`User ${userId} does not have an FCM token.`);
    return;
  }

  const message = {
    token: fcmToken,
    notification: {
      title: title,
      body: body,
    },
    // Optional data payload
    // data: {
    //   screen: 'home',
    // },
  };

  try {
    const response = await admin.messaging().send(message);
    console.log("Successfully sent message:", response);
  } catch (error) {
    console.error("Error sending message:", error);
  }
}
