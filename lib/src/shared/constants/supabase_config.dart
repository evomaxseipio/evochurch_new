// lib/src/shared/constants/supabase_config.dart

class SupabaseConfig {
  static const bool isLocal = true; // Cambiar a false para producción
  
  static String get url {
    if (isLocal) {
      // Puerto 8001 es el API Gateway (Kong) de Supabase en Docker
      // Kong maneja todas las peticiones REST API, Auth, Storage, etc.
      return 'http://127.0.0.1:8001';
    } else {
      return 'https://hxssxfgdhsfvkhigzlco.supabase.co';
    }
  }

  static String get anonKey {
    if (isLocal) {
      // Clave anónima de tu instalación Supabase local
      return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzU5Mzc3NjAwLCJleHAiOjE5MTcxNDQwMDB9.kG6YdQw6sbRRL1VHkLItSRXUJyj08ko1OwjK9Fmn1gc';
    } else {
      return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh4c3N4ZmdkaHNmdmtoaWd6bGNvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU5NDIyMTQsImV4cCI6MjA0MTUxODIxNH0.twlByPRucPMmUcB59PF7uyju1rELkymi6KNjzf_4q88';
    }
  }

  // Service Role Key (usar solo en backend/admin, NUNCA en cliente)
  static String get serviceRoleKey {
    if (isLocal) {
      return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NTkzNzc2MDAsImV4cCI6MTkxNzE0NDAwMH0.tq-6nGGt1QfOnQWc05IKeCG867qaBT3wQhRKkxA054U';
    } else {
      return ''; // Agregar service role key de producción si es necesario
    }
  }
}


 