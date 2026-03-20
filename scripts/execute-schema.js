import fs from 'fs';
import https from 'https';

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL;
const SUPABASE_ANON_KEY = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
  console.error('❌ Missing SUPABASE_URL or SUPABASE_ANON_KEY');
  process.exit(1);
}

async function executeSql(sql) {
  const body = JSON.stringify({ query: sql });
  
  return new Promise((resolve, reject) => {
    const req = https.request(
      `${SUPABASE_URL}/rest/v1/rpc/sql_query`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
          'Content-Length': Buffer.byteLength(body),
        },
      },
      (res) => {
        let data = '';
        res.on('data', (chunk) => { data += chunk; });
        res.on('end', () => {
          if (res.statusCode >= 200 && res.statusCode < 300) {
            resolve(data);
          } else {
            reject(new Error(`HTTP ${res.statusCode}: ${data}`));
          }
        });
      }
    );

    req.on('error', reject);
    req.write(body);
    req.end();
  });
}

async function executeFromFile(filePath) {
  try {
    const sql = fs.readFileSync(filePath, 'utf-8');
    console.log(`\n📄 Executing: ${filePath}`);
    await executeSql(sql);
    console.log(`✅ Success: ${filePath}`);
  } catch (error) {
    console.error(`❌ Error in ${filePath}:`, error.message);
    throw error;
  }
}

async function main() {
  try {
    console.log('🚀 Starting ChefPoint Database Schema Setup...\n');
    
    await executeFromFile('/vercel/share/v0-project/scripts/01-schema-fixed.sql');
    await executeFromFile('/vercel/share/v0-project/scripts/01b-functions.sql');
    await executeFromFile('/vercel/share/v0-project/scripts/02-seed.sql');
    
    console.log('\n✅ All scripts executed successfully!');
    console.log('📊 ChefPoint database is now ready.\n');
  } catch (error) {
    console.error('\n❌ Script execution failed:', error.message);
    process.exit(1);
  }
}

main();
