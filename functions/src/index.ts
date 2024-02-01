import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

exports.sendNotification = functions.region('asia-northeast1').firestore
    .document('users/{usersId}/notifications/{notificationId}')
    .onCreate(async (snapshot, context) => {
        const notificationData = snapshot.data();

        console.log('新しい通知が作成されました：', notificationData);

        // ユーザーIDを取得します。
        const userId = context.params.usersId;

        // ユーザーのトークンを取得します。
        const userDoc = await admin.firestore().collection('users').doc(userId).get();
        if (!userDoc.exists) {
            console.error('ユーザードキュメントが存在しません：', userId);
            return null;
        }
        const userData = userDoc.data();
        if (!userData || !userData.token) {
            console.error('ユーザートークンが存在しません：', userId);
            return null;
        }
        const token = userData.token;

        // 通知を送信します。
        try {
            const message = {
                token: token,
                notification: {
                    title: '新しい通知',
                    body: '新しい通知があります。',
                    // 他のオプションも設定できます。
                }
            };
        
            await admin.messaging().send(message);
            console.log('通知が送信されました。');
        } catch (error) {
            console.error('通知の送信に失敗しました：', error);
        }
        return null;
    });