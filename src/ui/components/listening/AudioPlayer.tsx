import React, { useState, useEffect, useRef, useCallback } from "react";
import { Play, Pause, Volume2, VolumeX, RotateCcw } from "lucide-react";
import { cn } from "@/lib/utils";

interface AudioPlayerProps {
  sectionIndex: number;
  audioUrl?: string;
  onEnded: () => void;
  disabled?: boolean;
}

const AudioPlayer: React.FC<AudioPlayerProps> = ({ sectionIndex, audioUrl, onEnded, disabled }) => {
  const audioRef = useRef<HTMLAudioElement | null>(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const [muted, setMuted] = useState(false);
  const [hasEnded, setHasEnded] = useState(false);
  const [useSimulated, setUseSimulated] = useState(!audioUrl);

  // Simulated fallback
  const SIMULATED_DURATIONS = [180, 210, 240, 300];
  const simulatedDuration = SIMULATED_DURATIONS[sectionIndex] || 180;
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  // Reset on section change or audioUrl change
  useEffect(() => {
    setIsPlaying(false);
    setCurrentTime(0);
    setHasEnded(false);
    setDuration(0);
    setUseSimulated(!audioUrl);
    if (intervalRef.current) clearInterval(intervalRef.current);

    if (audioUrl && audioRef.current) {
      audioRef.current.pause();
      audioRef.current.currentTime = 0;
    }
  }, [sectionIndex, audioUrl]);

  // Simulated playback
  useEffect(() => {
    if (!useSimulated) return;
    if (isPlaying && !hasEnded) {
      intervalRef.current = setInterval(() => {
        setCurrentTime((prev) => {
          const next = prev + 1;
          if (next >= simulatedDuration) {
            setIsPlaying(false);
            setHasEnded(true);
            if (intervalRef.current) clearInterval(intervalRef.current);
            onEnded();
            return simulatedDuration;
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
  }, [useSimulated, isPlaying, hasEnded, simulatedDuration, onEnded]);

  // Real audio event handlers
  const handleLoadedMetadata = () => {
    if (audioRef.current) {
      setDuration(audioRef.current.duration);
    }
  };

  const handleTimeUpdate = () => {
    if (audioRef.current) {
      setCurrentTime(audioRef.current.currentTime);
    }
  };

  const handleAudioEnded = () => {
    setIsPlaying(false);
    setHasEnded(true);
    onEnded();
  };

  const togglePlay = useCallback(() => {
    if (disabled || hasEnded) return;
    if (useSimulated) {
      setIsPlaying((p) => !p);
    } else if (audioRef.current) {
      if (isPlaying) {
        audioRef.current.pause();
      } else {
        audioRef.current.play();
      }
      setIsPlaying((p) => !p);
    }
  }, [disabled, hasEnded, useSimulated, isPlaying]);

  const restart = useCallback(() => {
    setCurrentTime(0);
    setHasEnded(false);
    setIsPlaying(true);
    if (!useSimulated && audioRef.current) {
      audioRef.current.currentTime = 0;
      audioRef.current.play();
    }
  }, [useSimulated]);

  useEffect(() => {
    if (audioRef.current) {
      audioRef.current.muted = muted;
    }
  }, [muted]);

  const effectiveDuration = useSimulated ? simulatedDuration : duration;
  const progress = effectiveDuration > 0 ? (currentTime / effectiveDuration) * 100 : 0;

  const fmt = (s: number) => {
    const m = Math.floor(s / 60);
    const sec = Math.floor(s % 60);
    return `${m}:${sec.toString().padStart(2, "0")}`;
  };

  return (
    <div
      className={cn(
        "flex items-center gap-3 rounded-xl border border-border bg-card p-3 transition-opacity",
        disabled && "opacity-50 pointer-events-none"
      )}
    >
      {/* Hidden audio element for real playback */}
      {audioUrl && (
        <audio
          ref={audioRef}
          src={audioUrl}
          preload="metadata"
          onLoadedMetadata={handleLoadedMetadata}
          onTimeUpdate={handleTimeUpdate}
          onEnded={handleAudioEnded}
        />
      )}

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
          <span>{effectiveDuration > 0 ? fmt(effectiveDuration) : "--:--"}</span>
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
