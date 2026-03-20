import { createClient } from '@supabase/supabase-js';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL;
const SUPABASE_ANON_KEY = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
  console.error('❌ Missing environment variables:');
  console.error('   - NEXT_PUBLIC_SUPABASE_URL');
  console.error('   - NEXT_PUBLIC_SUPABASE_ANON_KEY');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

async function executeSQL(sql, name) {
  try {
    console.log(`\n⏳ Executing: ${name}`);
    
    // Split SQL into statements and execute each one
    const statements = sql
      .split(';')
      .map(stmt => stmt.trim())
      .filter(stmt => stmt.length > 0 && !stmt.startsWith('--'));

    for (const statement of statements) {
      const { error } = await supabase.rpc('sql_query', { query: statement });
      if (error && !error.message.includes('already exists')) {
        throw error;
      }
    }
    
    console.log(`✅ Success: ${name}`);
  } catch (error) {
    console.error(`❌ Error in ${name}:`, error.message);
    throw error;
  }
}

async function loadAndExecute(filePath) {
  const sql = fs.readFileSync(path.join(__dirname, filePath), 'utf-8');
  const name = path.basename(filePath);
  await executeSQL(sql, name);
}

async function main() {
  try {
    console.log('🚀 Starting ChefPoint Database Setup...\n');
    console.log(`📍 Supabase Project: ${SUPABASE_URL}\n`);

    // Execute scripts in order
    await loadAndExecute('01-schema-fixed.sql');
    await loadAndExecute('01b-functions.sql');
    await loadAndExecute('02-seed.sql');

    console.log('\n✅ Database setup complete!');
    console.log('📊 All tables, indexes, and seed data are ready.\n');
  } catch (error) {
    console.error('\n❌ Setup failed:', error.message);
    process.exit(1);
  }
}

main();
