"use client";

import { useEffect, useRef } from 'react';
import { useRouter } from 'next/navigation';

export default function Home() {
  const router = useRouter();
  const hasChecked = useRef(false);

  useEffect(() => {
    if (hasChecked.current) return;
    hasChecked.current = true;

    // Check if user is authenticated via Azure Static Web Apps
    fetch('/.auth/me')
      .then(res => res.json())
      .then(data => {
        if (data.clientPrincipal) {
          // User is authenticated, redirect to quiz
          router.push('/quiz');
        }
      })
      .catch(err => console.error('Auth check failed:', err));
  }, [router]);

  return (
    <main className="bg-zinc-900 min-h-screen flex items-center justify-center font-sans text-amber-400">
      <div className="max-w-md w-full mx-auto px-4 py-8">
        <div className="space-y-8">
          {/* Header */}
          <div className="text-center">
            <h1 className="text-4xl font-bold text-amber-400 mb-2">BTE Learning App</h1>
            <p className="text-zinc-300">Master Behavioral Technical Events</p>
          </div>

          {/* Login Options */}
          <div className="bg-zinc-800 border border-amber-400/20 rounded-lg p-8">
            <h2 className="text-xl font-semibold text-center text-zinc-100 mb-6">Sign In</h2>

            <div className="space-y-3">
              <a
                href="/.auth/login/aad?post_login_redirect_uri=/quiz"
                className="w-full flex items-center justify-center gap-3 px-4 py-3 border border-zinc-600 rounded-lg text-zinc-100 hover:bg-zinc-700 transition-colors text-base"
              >
                <svg className="w-5 h-5 flex-shrink-0" viewBox="0 0 23 23">
                  <rect x="1" y="1" width="10" height="10" fill="#f25022"/>
                  <rect x="12" y="1" width="10" height="10" fill="#7fba00"/>
                  <rect x="1" y="12" width="10" height="10" fill="#00a4ef"/>
                  <rect x="12" y="12" width="10" height="10" fill="#ffb900"/>
                </svg>
                <span>Sign in with Microsoft</span>
              </a>
            </div>
          </div>

          <p className="text-center text-sm text-zinc-500">
            Powered by Azure Static Web Apps Authentication
          </p>
        </div>
      </div>
    </main>
  );
}
