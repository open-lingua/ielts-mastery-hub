import React from "react";
import { BookOpen, GraduationCap, Quote } from "lucide-react";
import { useTheme } from "@/contexts/ThemeContext";

export const AuthDecorativePanel: React.FC = () => {
  return (
    <div className="relative hidden lg:flex lg:w-1/2 flex-col justify-between overflow-hidden bg-primary p-12 text-primary-foreground">
      {/* Background pattern */}
      <div className="absolute inset-0 opacity-10">
        <div className="absolute -right-20 -top-20 h-80 w-80 rounded-full border-[40px] border-primary-foreground/20" />
        <div className="absolute -bottom-10 -left-10 h-60 w-60 rounded-full border-[30px] border-primary-foreground/20" />
        <div className="absolute bottom-1/3 right-1/4 h-40 w-40 rounded-full border-[20px] border-primary-foreground/10" />
        {/* Grid dots */}
        <svg className="absolute inset-0 h-full w-full" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <pattern id="dots" x="0" y="0" width="30" height="30" patternUnits="userSpaceOnUse">
              <circle cx="2" cy="2" r="1" fill="currentColor" opacity="0.3" />
            </pattern>
          </defs>
          <rect width="100%" height="100%" fill="url(#dots)" />
        </svg>
      </div>

      {/* Top branding */}
      <div className="relative z-10 flex items-center gap-3">
        <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-primary-foreground/10 backdrop-blur-sm">
          <BookOpen className="h-5 w-5" />
        </div>
        <div>
          <span className="text-lg font-bold">IELTS</span>{" "}
          <span className="text-lg font-medium text-primary-foreground/80">Mastery Hub</span>
        </div>
      </div>

      {/* Center quote */}
      <div className="relative z-10 space-y-6">
        <Quote className="h-10 w-10 text-primary-foreground/30" />
        <blockquote className="text-2xl font-serif leading-relaxed text-primary-foreground/90">
          "Education is the most powerful weapon which you can use to change the world."
        </blockquote>
        <div className="flex items-center gap-3">
          <div className="h-px flex-1 bg-primary-foreground/20" />
          <span className="text-sm font-medium text-primary-foreground/60">Nelson Mandela</span>
          <div className="h-px flex-1 bg-primary-foreground/20" />
        </div>

        {/* Stats */}
        <div className="mt-8 grid grid-cols-3 gap-4">
          {[
            { label: "Students", value: "50K+" },
            { label: "Avg. Band", value: "7.5" },
            { label: "Countries", value: "120+" },
          ].map((stat) => (
            <div key={stat.label} className="rounded-xl bg-primary-foreground/10 p-4 text-center backdrop-blur-sm">
              <div className="text-xl font-bold">{stat.value}</div>
              <div className="text-xs text-primary-foreground/60">{stat.label}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Bottom */}
      <div className="relative z-10 flex items-center gap-2 text-sm text-primary-foreground/50">
        <GraduationCap className="h-4 w-4" />
        <span>Your journey to Band 9 starts here</span>
      </div>
    </div>
  );
};
