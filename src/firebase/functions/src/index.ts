import {onObjectFinalized} from "firebase-functions/storage";
import {initializeApp, getApp} from "firebase-admin/app";
import {getStorage} from "firebase-admin/storage";
import {Metadata} from "./types";

initializeApp();
const projectId = getApp().options.projectId || process.env.GCLOUD_PROJECT;

export const updateCurrentAvatar = onObjectFinalized(
    {
      bucket: `${projectId}.firebasestorage.app`,
      region: "europe-north1",
    },
    async (event) => {
      const object = event.data;
      if (!object?.name) return;

      const objectPath = object.name;

      // Only process changes at avatars/{uid}/{timestamp}.jpg
      const match = objectPath.match(/^avatars\/([^/]+)\/[^/]+\.jpg$/);
      if (!match) return;

      const uid = match[1];

      // Prevent accidentally copying current.jpg back to itself
      if (objectPath.endsWith("current.jpg")) return;

      const bucket = getStorage().bucket();

      const sourceFile = bucket.file(objectPath);
      const destFile = bucket.file(`avatars/${uid}/current.jpg`);

      try {
        const metadata: Metadata = {
          cacheControl: "public,max-age=86400",
        };

        if (object.contentType) {
          metadata.contentType = object.contentType;
        }
        await sourceFile.copy(destFile, {metadata});
        console.log(`Updated current avatar for UID ${uid}`);
      } catch (err) {
        console.error(`Failed to update current avatar for UID ${uid}:`, err);
      }
    }
);
