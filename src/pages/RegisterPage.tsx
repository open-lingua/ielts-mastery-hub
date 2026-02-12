import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Mail, Lock, Eye, EyeOff, ArrowRight, Loader2, User, Chrome, Globe, GraduationCap, Building } from "lucide-react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { motion, AnimatePresence } from "framer-motion";
import { useAuth } from "@/contexts/AuthContext";
import { AuthDecorativePanel } from "@/components/AuthDecorativePanel";
import { useToast } from "@/hooks/use-toast";
import { CountryPicker } from "@/components/CountryPicker";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

const registerSchema = z
  .object({
    name: z.string().trim().min(1, "Name is required").max(100, "Name must be less than 100 characters"),
    email: z.string().trim().min(1, "Email is required").email("Enter a valid email"),
    password: z.string().min(6, "Must be at least 6 characters"),
    confirmPassword: z.string().min(1, "Please confirm your password"),
    country: z.string().min(1, "Please select your country"),
    educationLevel: z.string().min(1, "Please select your education level"),
    institution: z.string().max(200, "Must be less than 200 characters").optional().or(z.literal("")),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "Passwords do not match",
    path: ["confirmPassword"],
  });

type RegisterFormData = z.infer<typeof registerSchema>;

const educationOptions = [
  { value: "high_school", label: "High School" },
  { value: "undergraduate", label: "Undergraduate" },
  { value: "graduate", label: "Graduate" },
  { value: "postgraduate", label: "Postgraduate" },
  { value: "professional", label: "Professional" },
  { value: "other", label: "Other" },
];

const RegisterPage: React.FC = () => {
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();

  const {
    register,
    handleSubmit,
    setValue,
    watch,
    formState: { errors },
  } = useForm<RegisterFormData>({
    resolver: zodResolver(registerSchema),
    defaultValues: {
      name: "",
      email: "",
      password: "",
      confirmPassword: "",
      country: "",
      educationLevel: "",
      institution: "",
    },
  });

  const password = watch("password");
  const passwordStrength = password.length === 0 ? 0 : password.length < 6 ? 1 : password.length < 10 ? 2 : 3;
  const strengthColors = ["", "bg-destructive", "bg-warning", "bg-success"];
  const strengthLabels = ["", "Weak", "Fair", "Strong"];

  const onSubmit = async (data: RegisterFormData) => {
    setLoading(true);
    await new Promise((r) => setTimeout(r, 1500));
    login({ name: data.name, email: data.email });
    toast({ title: "Account created! 🎉", description: "Welcome to IELTS Mastery Hub." });
    navigate("/dashboard");
  };

  const inputClass = (hasError: boolean) =>
    `w-full rounded-xl border bg-card py-3 pl-10 pr-4 text-sm text-foreground placeholder:text-muted-foreground/50 outline-none transition-all focus:ring-2 focus:ring-primary/30 ${
      hasError ? "border-destructive ring-2 ring-destructive/20" : "border-border"
    }`;

  return (
    <div className="flex min-h-screen bg-background">
      <AuthDecorativePanel />

      <div className="flex w-full flex-col justify-center px-6 py-12 lg:w-1/2 lg:px-16 xl:px-24">
        <div className="mx-auto w-full max-w-md animate-fade-in">
          <div className="mb-8 flex items-center gap-2 lg:hidden">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground">
              <User className="h-4 w-4" />
            </div>
            <span className="font-bold text-primary">IELTS</span>
            <span className="font-medium text-foreground">Mastery Hub</span>
          </div>

          <h1 className="text-3xl font-bold text-foreground">Create your account</h1>
          <p className="mt-2 text-muted-foreground">Start your IELTS preparation journey today.</p>

          {/* Google Sign Up */}
          <button
            onClick={async () => {
              setGoogleLoading(true);
              await new Promise((r) => setTimeout(r, 1500));
              login({ name: "New User", email: "google_user@example.com" });
              toast({ title: "Account created! 🎉", description: "Signed up with Google." });
              navigate("/dashboard");
            }}
            disabled={googleLoading || loading}
            className="mt-8 flex w-full items-center justify-center gap-3 rounded-xl border border-border bg-card py-3 text-sm font-medium text-foreground transition-all hover:bg-secondary disabled:opacity-60"
          >
            {googleLoading ? (
              <Loader2 className="h-5 w-5 animate-spin text-muted-foreground" />
            ) : (
              <>
                <Chrome className="h-5 w-5" />
                Sign up with Google
              </>
            )}
          </button>

          {/* Divider */}
          <div className="my-6 flex items-center gap-4">
            <div className="h-px flex-1 bg-border" />
            <span className="text-xs font-medium text-muted-foreground uppercase tracking-wider">Or continue with email</span>
            <div className="h-px flex-1 bg-border" />
          </div>

          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            {/* Full Name */}
            <div>
              <label className="mb-1.5 block text-sm font-medium text-foreground">Full Name</label>
              <div className="relative">
                <User className="absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                <input
                  {...register("name")}
                  placeholder="John Doe"
                  className={inputClass(!!errors.name)}
                />
              </div>
              {errors.name && <p className="mt-1 text-xs text-destructive">{errors.name.message}</p>}
            </div>

            {/* Email */}
            <div>
              <label className="mb-1.5 block text-sm font-medium text-foreground">Email</label>
              <div className="relative">
                <Mail className="absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                <input
                  {...register("email")}
                  type="email"
                  placeholder="you@example.com"
                  className={inputClass(!!errors.email)}
                />
              </div>
              {errors.email && <p className="mt-1 text-xs text-destructive">{errors.email.message}</p>}
            </div>

            {/* Password */}
            <div>
              <label className="mb-1.5 block text-sm font-medium text-foreground">Password</label>
              <div className="relative">
                <Lock className="absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                <input
                  {...register("password")}
                  type={showPassword ? "text" : "password"}
                  placeholder="Min. 6 characters"
                  className={`${inputClass(!!errors.password)} !pr-12`}
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3.5 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground transition-colors"
                >
                  {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </button>
              </div>
              {errors.password && <p className="mt-1 text-xs text-destructive">{errors.password.message}</p>}
              {password.length > 0 && (
                <div className="mt-2 flex items-center gap-2">
                  <div className="flex flex-1 gap-1">
                    {[1, 2, 3].map((level) => (
                      <div
                        key={level}
                        className={`h-1 flex-1 rounded-full transition-colors ${
                          passwordStrength >= level ? strengthColors[passwordStrength] : "bg-border"
                        }`}
                      />
                    ))}
                  </div>
                  <span className="text-xs text-muted-foreground">{strengthLabels[passwordStrength]}</span>
                </div>
              )}
            </div>

            {/* Confirm Password */}
            <div>
              <label className="mb-1.5 block text-sm font-medium text-foreground">Confirm Password</label>
              <div className="relative">
                <Lock className="absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                <input
                  {...register("confirmPassword")}
                  type={showConfirm ? "text" : "password"}
                  placeholder="Repeat your password"
                  className={`${inputClass(!!errors.confirmPassword)} !pr-12`}
                />
                <button
                  type="button"
                  onClick={() => setShowConfirm(!showConfirm)}
                  className="absolute right-3.5 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground transition-colors"
                >
                  {showConfirm ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </button>
              </div>
              {errors.confirmPassword && <p className="mt-1 text-xs text-destructive">{errors.confirmPassword.message}</p>}
            </div>

            {/* Country & Education - animated section */}
            <motion.div
              initial={{ opacity: 0, y: 12 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.15, duration: 0.4 }}
              className="space-y-4 pt-2"
            >
              {/* Country */}
              <div>
                <label className="mb-1.5 block text-sm font-medium text-foreground">Country</label>
                <div className="relative">
                  <Globe className="absolute left-3.5 top-1/2 z-10 h-4 w-4 -translate-y-1/2 text-muted-foreground pointer-events-none" />
                  <CountryPicker
                    value={watch("country")}
                    onChange={(v) => setValue("country", v, { shouldValidate: true })}
                    hasError={!!errors.country}
                  />
                </div>
                {errors.country && <p className="mt-1 text-xs text-destructive">{errors.country.message}</p>}
              </div>

              {/* Education Level */}
              <div>
                <label className="mb-1.5 block text-sm font-medium text-foreground">Education Level</label>
                <div className="relative">
                  <GraduationCap className="absolute left-3.5 top-1/2 z-10 h-4 w-4 -translate-y-1/2 text-muted-foreground pointer-events-none" />
                  <Select
                    value={watch("educationLevel")}
                    onValueChange={(v) => setValue("educationLevel", v, { shouldValidate: true })}
                  >
                    <SelectTrigger
                      className={`w-full rounded-xl border bg-card py-3 pl-10 pr-4 text-sm h-auto outline-none transition-all focus:ring-2 focus:ring-primary/30 ${
                        errors.educationLevel ? "border-destructive ring-2 ring-destructive/20" : "border-border"
                      }`}
                    >
                      <SelectValue placeholder="Select education level" />
                    </SelectTrigger>
                    <SelectContent>
                      {educationOptions.map((opt) => (
                        <SelectItem key={opt.value} value={opt.value}>
                          {opt.label}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                {errors.educationLevel && <p className="mt-1 text-xs text-destructive">{errors.educationLevel.message}</p>}
              </div>

              {/* Institution */}
              <div>
                <label className="mb-1.5 block text-sm font-medium text-foreground">School / University</label>
                <div className="relative">
                  <Building className="absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                  <input
                    {...register("institution")}
                    placeholder="e.g. University of Cambridge"
                    className={inputClass(!!errors.institution)}
                  />
                </div>
                <p className="mt-1 text-xs text-muted-foreground">Optional: Provide the name of your current or most recent institution.</p>
                {errors.institution && <p className="mt-1 text-xs text-destructive">{errors.institution.message}</p>}
              </div>
            </motion.div>

            <button
              type="submit"
              disabled={loading || googleLoading}
              className="group flex w-full items-center justify-center gap-2 rounded-xl bg-primary py-3 text-sm font-semibold text-primary-foreground shadow-lg shadow-primary/20 transition-all hover:scale-[1.02] active:scale-[0.98] disabled:opacity-60 disabled:hover:scale-100"
            >
              {loading ? (
                <Loader2 className="h-5 w-5 animate-spin" />
              ) : (
                <>
                  Create Account
                  <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-1" />
                </>
              )}
            </button>
          </form>

          <p className="mt-8 text-center text-sm text-muted-foreground">
            Already have an account?{" "}
            <Link to="/login" className="font-semibold text-primary hover:underline">
              Login
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
};

export default RegisterPage;
