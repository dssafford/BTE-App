"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useState } from "react";

// A simple user icon component
const UserIcon = () => (
  <svg xmlns="http://www.w3.org/2000/svg" className="h-8 w-8 rounded-full bg-zinc-700 text-amber-400 p-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
  </svg>
);

export default function NavBar() {
  const pathname = usePathname();
  const [isOpen, setIsOpen] = useState(false);
  
  // --- Mock Authentication State ---
  // Replace this with your actual auth context or state management
  const [user, setUser] = useState<{ name: string } | null>(null);
  // To test the logged-in view, you can temporarily set the initial state to:
  // const [user, setUser] = useState<{ name: string } | null>({ name: "Doug" });
  // --- End Mock ---

  const links = [
    { href: "/", label: "Home" },
    { href: "/quiz", label: "Quiz" },
    { href: "/history", label: "History" },
    { href: "/study", label: "Study" },
    { href: "/wrongs", label: "Wrongs" },
    { href: "/numbers/study", label: "Numbers Study" },
    { href: "/numbers/quiz", label: "Numbers Quiz" },
  ];

  // This is a mock login/logout function for demonstration purposes
  const handleLogin = (e: React.MouseEvent) => {
    e.preventDefault(); // Prevent navigation
    setUser({ name: "Doug" });
  };
  
  const handleLogout = (e: React.MouseEvent) => {
    e.preventDefault(); // Prevent navigation
    setUser(null);
  };

  return (
    <nav className="w-full bg-zinc-800 border-b-2 border-amber-400 p-3 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto flex justify-between items-center">
        <div className="text-amber-400 text-2xl font-bold">
          <Link href="/">BTE</Link>
        </div>

        {/* Desktop Menu */}
        <div className="hidden md:flex items-center space-x-8">
          {links.map(link => {
            const isActive = pathname === link.href;
            return (
              <Link
                key={link.href}
                href={link.href}
                className={`transition-colors duration-200 font-bold text-lg rounded-md px-3 py-1 ${
                  isActive ? "bg-amber-400 text-zinc-900" : "text-amber-400 hover:bg-zinc-700"
                }`}
              >
                {link.label}
              </Link>
            );
          })}
        </div>

        <div className="hidden md:flex items-center space-x-4">
          {user ? (
            <>
              <div className="flex items-center space-x-2">
                <UserIcon />
                <span className="text-amber-400 font-semibold">{user.name}</span>
              </div>
              <Link href="/logout" onClick={handleLogout} className="text-amber-400 hover:text-amber-300 font-bold text-lg">
                Logout
              </Link>
            </>
          ) : (
            <Link href="/login" onClick={handleLogin} className="text-amber-400 hover:text-amber-300 font-bold text-lg">
              Login
            </Link>
          )}
        </div>

        {/* Mobile Menu Button */}
        <div className="md:hidden">
          <button onClick={() => setIsOpen(!isOpen)} className="text-amber-400 focus:outline-none">
            <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d={isOpen ? "M6 18L18 6M6 6l12 12" : "M4 6h16M4 12h16m-7 6h7"}></path>
            </svg>
          </button>
        </div>
      </div>

      {/* Mobile Menu */}
      {isOpen && (
        <div className="md:hidden mt-4">
          <div className="flex flex-col space-y-4">
            {links.map(link => {
              const isActive = pathname === link.href;
              return (
                <Link
                  key={link.href}
                  href={link.href}
                  onClick={() => setIsOpen(false)}
                  className={`transition-colors duration-200 font-bold text-lg rounded-md px-3 py-2 text-center ${
                    isActive ? "bg-amber-400 text-zinc-900" : "text-amber-400 hover:bg-zinc-700"
                  }`}
                >
                  {link.label}
                </Link>
              );
            })}
            <div className="flex justify-center items-center space-x-6 pt-4 border-t border-zinc-700">
              {user ? (
                <>
                  <div className="flex items-center space-x-2">
                    <UserIcon />
                    <span className="text-amber-400 font-semibold">{user.name}</span>
                  </div>
                  <Link href="/logout" onClick={(e) => { handleLogout(e); setIsOpen(false); }} className="text-amber-400 hover:text-amber-300 font-bold text-lg">
                    Logout
                  </Link>
                </>
              ) : (
                <Link href="/login" onClick={(e) => { handleLogin(e); setIsOpen(false); }} className="text-amber-400 hover:text-amber-300 font-bold text-lg">
                  Login
                </Link>
              )}
            </div>
          </div>
        </div>
      )}
    </nav>
  );
} 