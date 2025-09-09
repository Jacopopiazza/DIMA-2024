import { S3Client, GetObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { Context } from 'aws-lambda';

// Types for AppSync event
interface AppSyncEvent {
  arguments: {
    objectKey: string;
  };
}

interface PresignedUrlResponse {
  url: string;
  expiresIn: number;
  expiresAt: string;
  bucketName: string;
  objectKey: string;
  generatedAt: string;
}

// Environment variables
const BUCKET_NAME = process.env.PROFILE_PICTURES_BUCKET_NAME;
const AWS_REGION = process.env.AWS_REGION || 'us-west-2';

if (!BUCKET_NAME) {
  throw new Error(
    'PROFILE_PICTURES_BUCKET_NAME environment variable is required',
  );
}

// Initialize S3 client
const s3Client = new S3Client({
  region: AWS_REGION,
});

export const handler = async (
  event: AppSyncEvent,
  context: Context,
): Promise<PresignedUrlResponse> => {
  console.log('Event received:', JSON.stringify(event, null, 2));
  console.log('Context:', JSON.stringify(context, null, 2));

  try {
    // Extract arguments from AppSync event
    const { objectKey } = event.arguments;

    // Validate required parameters
    if (!objectKey) {
      throw new Error('objectKey is required parameter');
    }

    // Create the GetObject command
    const command = new GetObjectCommand({
      Bucket: BUCKET_NAME,
      Key: objectKey,
      // Optional: Add response headers to control how the file is displayed
      ResponseContentDisposition: 'inline', // Use 'attachment' to force download
      ResponseCacheControl: 'max-age=3600', // Cache for 1 hour in browser
    });

    // Generate presigned URL with 7 days expiration
    const presignedUrl = await getSignedUrl(s3Client, command, {
      expiresIn: 7 * 24 * 60 * 60, // 7 days in seconds (604800 seconds)
    });

    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);

    // Return the presigned URL with metadata
    const response: PresignedUrlResponse = {
      url: presignedUrl,
      expiresIn: 7 * 24 * 60 * 60,
      expiresAt: expiresAt.toISOString(),
      bucketName: BUCKET_NAME,
      objectKey,
      generatedAt: new Date().toISOString(),
    };

    console.log('Presigned URL generated successfully:', {
      objectKey,
      bucketName: BUCKET_NAME,
      expiresAt: response.expiresAt,
    });

    return response;
  } catch (error) {
    console.error('Error generating presigned URL:', error);

    // Return error in AppSync-compatible format
    const errorMessage = error instanceof Error ? error.message : String(error);
    throw new Error(`Failed to generate presigned URL: ${errorMessage}`);
  }
};
