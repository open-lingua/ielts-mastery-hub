import { motion } from "framer-motion";
import { BrainCircuit, Sparkles } from "lucide-react";
import type React from "react";

const WritingGradingLoader: React.FC = () => (
  <div className="fixed inset-0 z-50 flex items-center justify-center bg-background/80 backdrop-blur-md">
    <motion.div
      initial={{ opacity: 0, scale: 0.9 }}
      animate={{ opacity: 1, scale: 1 }}
      className="flex flex-col items-center gap-6 text-center max-w-sm"
    >
      <div className="relative">
        <motion.div
          animate={{ scale: [1, 1.15, 1] }}
          transition={{ repeat: Infinity, duration: 2, ease: "easeInOut" }}
          className="h-20 w-20 rounded-2xl bg-primary/10 flex items-center justify-center"
        >
          <BrainCircuit className="h-10 w-10 text-primary" />
        </motion.div>
        <motion.div
          animate={{ rotate: 360 }}
          transition={{ repeat: Infinity, duration: 3, ease: "linear" }}
          className="absolute -top-2 -right-2"
        >
          <Sparkles className="h-5 w-5 text-warning" />
        </motion.div>
      </div>

      <div className="space-y-2">
        <h2 className="text-xl font-bold text-foreground">AI is evaluating your writing</h2>
        <p className="text-sm text-muted-foreground">
          Analysing task achievement, coherence, vocabulary, and grammar…
          <br />
          This usually takes 10–15 seconds.
        </p>
      </div>

      <div className="flex gap-1.5">
        {[0, 1, 2].map((i) => (
          <motion.div
            key={i}
            animate={{ opacity: [0.3, 1, 0.3] }}
            transition={{ repeat: Infinity, duration: 1.2, delay: i * 0.3 }}
            className="h-2 w-2 rounded-full bg-primary"
          />
        ))}
      </div>
    </motion.div>
  </div>
);

export default WritingGradingLoader;
