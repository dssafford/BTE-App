"use client";

import { Inter } from "next/font/google";
import "./globals.css";
import NavBar from "./components/NavBar";
import { usePathname } from "next/navigation";

const inter = Inter({ subsets: ["latin"] });

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const pathname = usePathname();
  const isLoginPage = pathname === "/";

  return (
    <html lang="en">
      <body className={inter.className}>
        {!isLoginPage && <NavBar />}
        {children}
      </body>
    </html>
  );
}
