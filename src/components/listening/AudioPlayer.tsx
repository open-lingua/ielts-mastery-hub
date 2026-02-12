import React, { useState, useEffect, useRef, useCallback } from "react";
import { Play, Pause, Volume2, VolumeX, RotateCcw } from "lucide-react";
import { cn } from "@/lib/utils";

interface AudioPlayerProps {
  sectionIndex: number;
  onEnded: () => void;
  disabled?: boolean;
}

// Simulated audio durations per section (seconds)
const SECTION_DURATIONS = [180, 210, 240, 300];

const AudioPlayer: React.FC<AudioPlayerProps> = ({ sectionIndex, onEnded, disabled }) => {
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [muted, setMuted] = useState(false);
  const [hasEnded, setHasEnded] = useState(false);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const duration = SECTION_DURATIONS[sectionIndex] || 180;

  // Reset on section change
  useEffect(() => {
    setIsPlaying(false);
    setCurrentTime(0);
    setHasEnded(false);
    if (intervalRef.current) clearInterval(intervalRef.current);
  }, [sectionIndex]);

  useEffect(() => {
    if (isPlaying && !hasEnded) {
      intervalRef.current = setInterval(() => {
        setCurrentTime((prev) => {
          const next = prev + 1;
          if (next >= duration) {
            setIsPlaying(false);
            setHasEnded(true);
            if (intervalRef.current) clearInterval(intervalRef.current);
            onEnded();
            return duration;
          }
          return next;
        });
      }, 1000);
    } else {
      if (intervalRef.current) clearInterval(intervalRef.current);
    }
    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current);
    };
  }, [isPlaying, hasEnded, duration, onEnded]);

  const togglePlay = useCallback(() => {
    if (disabled || hasEnded) return;
    setIsPlaying((p) => !p);
  }, [disabled, hasEnded]);

  const restart = useCallback(() => {
    setCurrentTime(0);
    setHasEnded(false);
    setIsPlaying(true);
  }, []);

  const fmt = (s: number) => {
    const m = Math.floor(s / 60);
    const sec = Math.floor(s % 60);
    return `${m}:${sec.toString().padStart(2, "0")}`;
  };

  const progress = (currentTime / duration) * 100;

  return (
    <div
      className={cn(
        "flex items-center gap-3 rounded-xl border border-border bg-card p-3 transition-opacity",
        disabled && "opacity-50 pointer-events-none"
      )}
    >
      <button
        onClick={hasEnded ? restart : togglePlay}
        className={cn(
          "flex h-10 w-10 shrink-0 items-center justify-center rounded-full transition-transform hover:scale-105",
          hasEnded
            ? "bg-muted text-muted-foreground"
            : "bg-primary text-primary-foreground shadow-md shadow-primary/20"
        )}
      >
        {hasEnded ? (
          <RotateCcw className="h-4 w-4" />
        ) : isPlaying ? (
          <Pause className="h-4 w-4" />
        ) : (
          <Play className="h-4 w-4 ml-0.5" />
        )}
      </button>

      <div className="flex-1 min-w-0">
        <div className="relative h-2 w-full rounded-full bg-secondary overflow-hidden">
          <div
            className={cn(
              "absolute inset-y-0 left-0 rounded-full transition-all duration-300",
              hasEnded ? "bg-success" : "bg-primary"
            )}
            style={{ width: `${progress}%` }}
          />
        </div>
        <div className="flex justify-between mt-1 text-[10px] text-muted-foreground font-mono">
          <span>{fmt(currentTime)}</span>
          <span>{fmt(duration)}</span>
        </div>
      </div>

      <button
        onClick={() => setMuted((m) => !m)}
        className="rounded-lg p-2 text-muted-foreground hover:bg-secondary hover:text-foreground transition-colors"
      >
        {muted ? <VolumeX className="h-4 w-4" /> : <Volume2 className="h-4 w-4" />}
      </button>

      {hasEnded && (
        <span className="text-[10px] font-semibold text-success uppercase tracking-wider shrink-0">
          Ended
        </span>
      )}
    </div>
  );
};

export default AudioPlayer;
