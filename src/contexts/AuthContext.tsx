import React, { createContext, useContext, useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { User } from '../types';
import { toast } from 'react-hot-toast';

interface AuthContextType {
  user: User | null;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
  loading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

let cachedUser: User | null = null; // Cache for user data

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(cachedUser);
  const [loading, setLoading] = useState(!cachedUser);

  const fetchUserData = async (userId: string) => {
    try {
      const { data: userData, error: userError } = await supabase
        .from('users')
        .select('*')
        .eq('id', userId)
        .single();

      if (userError) {
        if (userError.code === 'PGRST116') {
          const session = await supabase.auth.getSession();
          if (session.data.session?.user.email) {
            const { data: newProfile, error: createError } = await supabase
              .from('users')
              .insert([
                {
                  id: userId,
                  email: session.data.session.user.email,
                  first_name: 'User',
                  last_name: session.data.session.user.email.split('@')[0] || 'Unknown',
                  role: 'employee',
                  department: 'Unassigned',
                },
              ])
              .select()
              .single();

            if (createError) throw createError;
            cachedUser = newProfile;
            setUser(newProfile);
            return;
          }
        }
        throw userError;
      }

      cachedUser = userData; // Cache the user data
      setUser(userData);
    } catch (error: any) {
      console.error('Error in fetchUserData:', error);
      toast.error('Une erreur est survenue lors de la récupération des données utilisateur.');
      if (error.code !== 'PGRST116') {
        await supabase.auth.signOut();
      }
      setUser(null);
    }
  };

  useEffect(() => {
    let mounted = true;

    const initializeAuth = async () => {
      try {
        const { data: { session } } = await supabase.auth.getSession();

        if (session?.user && mounted) {
          await fetchUserData(session.user.id);
        }
      } catch (error) {
        console.error('Error in initializeAuth:', error);
        toast.error('Erreur lors de l’initialisation de la session.');
      } finally {
        if (mounted) {
          setLoading(false);
        }
      }
    };

    initializeAuth();

    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
      if (mounted) {
        if (session?.user) {
          await fetchUserData(session.user.id);
        } else {
          cachedUser = null;
          setUser(null);
        }
        setLoading(false);
      }
    });

    return () => {
      mounted = false;
      subscription.unsubscribe();
    };
  }, []);

  const signIn = async (email: string, password: string) => {
    try {
      const { error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) throw error;
      toast.success('Connexion réussie !');
    } catch (error) {
      console.error('Sign in error:', error);
      toast.error('Connexion échouée. Vérifiez vos identifiants.');
      throw error;
    }
  };

  const signOut = async () => {
    try {
      const { error } = await supabase.auth.signOut();
      if (error) throw error;
      cachedUser = null;
      setUser(null);
      toast.success('Déconnexion réussie.');
    } catch (error) {
      console.error('Sign out error:', error);
      toast.error('Erreur lors de la déconnexion.');
      throw error;
    }
  };

  return (
    <AuthContext.Provider value={{ user, signIn, signOut, loading }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
