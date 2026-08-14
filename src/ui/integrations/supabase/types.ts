export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.1";
  };
  public: {
    Tables: {
      listening_question_groups: {
        Row: {
          created_at: string;
          group_order: number;
          has_word_bank: boolean;
          id: string;
          instructions: string;
          multiple_selection: boolean;
          question_type: string;
          section_id: string;
          select_count: number;
          sequential_order: boolean;
          word_bank: Json | null;
          word_limit: string | null;
        };
        Insert: {
          created_at?: string;
          group_order?: number;
          has_word_bank?: boolean;
          id?: string;
          instructions?: string;
          multiple_selection?: boolean;
          question_type?: string;
          section_id: string;
          select_count?: number;
          sequential_order?: boolean;
          word_bank?: Json | null;
          word_limit?: string | null;
        };
        Update: {
          created_at?: string;
          group_order?: number;
          has_word_bank?: boolean;
          id?: string;
          instructions?: string;
          multiple_selection?: boolean;
          question_type?: string;
          section_id?: string;
          select_count?: number;
          sequential_order?: boolean;
          word_bank?: Json | null;
          word_limit?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: "listening_question_groups_section_id_fkey";
            columns: ["section_id"];
            isOneToOne: false;
            referencedRelation: "listening_sections";
            referencedColumns: ["id"];
          },
        ];
      };
      listening_questions: {
        Row: {
          accepted_answers: Json | null;
          answer: string | null;
          completion_gaps: Json | null;
          created_at: string;
          group_id: string;
          id: string;
          matching_pairs: Json | null;
          options: Json | null;
          question_order: number;
          text: string;
          timestamp: string | null;
        };
        Insert: {
          accepted_answers?: Json | null;
          answer?: string | null;
          completion_gaps?: Json | null;
          created_at?: string;
          group_id: string;
          id?: string;
          matching_pairs?: Json | null;
          options?: Json | null;
          question_order?: number;
          text?: string;
          timestamp?: string | null;
        };
        Update: {
          accepted_answers?: Json | null;
          answer?: string | null;
          completion_gaps?: Json | null;
          created_at?: string;
          group_id?: string;
          id?: string;
          matching_pairs?: Json | null;
          options?: Json | null;
          question_order?: number;
          text?: string;
          timestamp?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: "listening_questions_group_id_fkey";
            columns: ["group_id"];
            isOneToOne: false;
            referencedRelation: "listening_question_groups";
            referencedColumns: ["id"];
          },
        ];
      };
      listening_sections: {
        Row: {
          audio_url: string | null;
          created_at: string;
          id: string;
          section_number: number;
          test_id: string;
          title: string;
          transcript: string | null;
        };
        Insert: {
          audio_url?: string | null;
          created_at?: string;
          id?: string;
          section_number?: number;
          test_id: string;
          title?: string;
          transcript?: string | null;
        };
        Update: {
          audio_url?: string | null;
          created_at?: string;
          id?: string;
          section_number?: number;
          test_id?: string;
          title?: string;
          transcript?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: "listening_sections_test_id_fkey";
            columns: ["test_id"];
            isOneToOne: false;
            referencedRelation: "listening_tests";
            referencedColumns: ["id"];
          },
        ];
      };
      listening_tests: {
        Row: {
          created_at: string;
          created_by: string;
          difficulty: string;
          duration: string;
          id: string;
          status: string;
          title: string;
          updated_at: string;
        };
        Insert: {
          created_at?: string;
          created_by: string;
          difficulty?: string;
          duration?: string;
          id?: string;
          status?: string;
          title?: string;
          updated_at?: string;
        };
        Update: {
          created_at?: string;
          created_by?: string;
          difficulty?: string;
          duration?: string;
          id?: string;
          status?: string;
          title?: string;
          updated_at?: string;
        };
        Relationships: [];
      };
      payments: {
        Row: {
          amount: number;
          created_at: string;
          currency: string;
          id: string;
          lemon_squeezy_order_id: string | null;
          lemon_squeezy_payment_id: string | null;
          payment_method: string | null;
          plan_id: string | null;
          receipt_url: string | null;
          refunded_at: string | null;
          status: string;
          subscription_id: string | null;
          updated_at: string;
          user_email: string;
          user_id: string | null;
        };
        Insert: {
          amount: number;
          created_at?: string;
          currency?: string;
          id?: string;
          lemon_squeezy_order_id?: string | null;
          lemon_squeezy_payment_id?: string | null;
          payment_method?: string | null;
          plan_id?: string | null;
          receipt_url?: string | null;
          refunded_at?: string | null;
          status?: string;
          subscription_id?: string | null;
          updated_at?: string;
          user_email: string;
          user_id?: string | null;
        };
        Update: {
          amount?: number;
          created_at?: string;
          currency?: string;
          id?: string;
          lemon_squeezy_order_id?: string | null;
          lemon_squeezy_payment_id?: string | null;
          payment_method?: string | null;
          plan_id?: string | null;
          receipt_url?: string | null;
          refunded_at?: string | null;
          status?: string;
          subscription_id?: string | null;
          updated_at?: string;
          user_email?: string;
          user_id?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: "payments_plan_id_fkey";
            columns: ["plan_id"];
            isOneToOne: false;
            referencedRelation: "plans";
            referencedColumns: ["id"];
          },
          {
            foreignKeyName: "payments_subscription_id_fkey";
            columns: ["subscription_id"];
            isOneToOne: false;
            referencedRelation: "subscriptions";
            referencedColumns: ["id"];
          },
        ];
      };
      plans: {
        Row: {
          billing_period: string;
          checkout_url: string;
          created_at: string;
          description: string | null;
          features: Json;
          id: string;
          is_popular: boolean | null;
          lemon_squeezy_variant_id: string | null;
          name: string;
          price: number;
          sort_order: number | null;
          updated_at: string;
        };
        Insert: {
          billing_period: string;
          checkout_url: string;
          created_at?: string;
          description?: string | null;
          features?: Json;
          id?: string;
          is_popular?: boolean | null;
          lemon_squeezy_variant_id?: string | null;
          name: string;
          price: number;
          sort_order?: number | null;
          updated_at?: string;
        };
        Update: {
          billing_period?: string;
          checkout_url?: string;
          created_at?: string;
          description?: string | null;
          features?: Json;
          id?: string;
          is_popular?: boolean | null;
          lemon_squeezy_variant_id?: string | null;
          name?: string;
          price?: number;
          sort_order?: number | null;
          updated_at?: string;
        };
        Relationships: [];
      };
      profiles: {
        Row: {
          avatar_url: string | null;
          ban_reason: string | null;
          banned_until: string | null;
          email: string | null;
          full_name: string | null;
          id: string;
          is_banned: boolean;
          plan_type: string | null;
          updated_at: string | null;
        };
        Insert: {
          avatar_url?: string | null;
          ban_reason?: string | null;
          banned_until?: string | null;
          email?: string | null;
          full_name?: string | null;
          id: string;
          is_banned?: boolean;
          plan_type?: string | null;
          updated_at?: string | null;
        };
        Update: {
          avatar_url?: string | null;
          ban_reason?: string | null;
          banned_until?: string | null;
          email?: string | null;
          full_name?: string | null;
          id?: string;
          is_banned?: boolean;
          plan_type?: string | null;
          updated_at?: string | null;
        };
        Relationships: [];
      };
      reading_passages: {
        Row: {
          content: string;
          created_at: string;
          id: string;
          notes: string | null;
          passage_number: number;
          test_id: string;
          title: string;
        };
        Insert: {
          content?: string;
          created_at?: string;
          id?: string;
          notes?: string | null;
          passage_number?: number;
          test_id: string;
          title?: string;
        };
        Update: {
          content?: string;
          created_at?: string;
          id?: string;
          notes?: string | null;
          passage_number?: number;
          test_id?: string;
          title?: string;
        };
        Relationships: [
          {
            foreignKeyName: "reading_passages_test_id_fkey";
            columns: ["test_id"];
            isOneToOne: false;
            referencedRelation: "reading_tests";
            referencedColumns: ["id"];
          },
        ];
      };
      reading_question_groups: {
        Row: {
          created_at: string;
          group_order: number;
          has_word_bank: boolean;
          id: string;
          instructions: string;
          multiple_selection: boolean;
          passage_id: string;
          question_type: string;
          select_count: number;
          sequential_order: boolean;
          word_bank: Json | null;
          word_limit: string | null;
        };
        Insert: {
          created_at?: string;
          group_order?: number;
          has_word_bank?: boolean;
          id?: string;
          instructions?: string;
          multiple_selection?: boolean;
          passage_id: string;
          question_type?: string;
          select_count?: number;
          sequential_order?: boolean;
          word_bank?: Json | null;
          word_limit?: string | null;
        };
        Update: {
          created_at?: string;
          group_order?: number;
          has_word_bank?: boolean;
          id?: string;
          instructions?: string;
          multiple_selection?: boolean;
          passage_id?: string;
          question_type?: string;
          select_count?: number;
          sequential_order?: boolean;
          word_bank?: Json | null;
          word_limit?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: "reading_question_groups_passage_id_fkey";
            columns: ["passage_id"];
            isOneToOne: false;
            referencedRelation: "reading_passages";
            referencedColumns: ["id"];
          },
        ];
      };
      reading_questions: {
        Row: {
          accepted_answers: Json | null;
          answer: string | null;
          completion_gaps: Json | null;
          created_at: string;
          group_id: string;
          id: string;
          matching_pairs: Json | null;
          options: Json | null;
          question_order: number;
          text: string;
        };
        Insert: {
          accepted_answers?: Json | null;
          answer?: string | null;
          completion_gaps?: Json | null;
          created_at?: string;
          group_id: string;
          id?: string;
          matching_pairs?: Json | null;
          options?: Json | null;
          question_order?: number;
          text?: string;
        };
        Update: {
          accepted_answers?: Json | null;
          answer?: string | null;
          completion_gaps?: Json | null;
          created_at?: string;
          group_id?: string;
          id?: string;
          matching_pairs?: Json | null;
          options?: Json | null;
          question_order?: number;
          text?: string;
        };
        Relationships: [
          {
            foreignKeyName: "reading_questions_group_id_fkey";
            columns: ["group_id"];
            isOneToOne: false;
            referencedRelation: "reading_question_groups";
            referencedColumns: ["id"];
          },
        ];
      };
      reading_tests: {
        Row: {
          created_at: string;
          created_by: string;
          difficulty: string;
          duration: string;
          id: string;
          status: string;
          test_type: string;
          title: string;
          updated_at: string;
        };
        Insert: {
          created_at?: string;
          created_by: string;
          difficulty?: string;
          duration?: string;
          id?: string;
          status?: string;
          test_type?: string;
          title?: string;
          updated_at?: string;
        };
        Update: {
          created_at?: string;
          created_by?: string;
          difficulty?: string;
          duration?: string;
          id?: string;
          status?: string;
          test_type?: string;
          title?: string;
          updated_at?: string;
        };
        Relationships: [];
      };
      subscriptions: {
        Row: {
          cancelled_at: string | null;
          created_at: string;
          current_period_end: string | null;
          current_period_start: string | null;
          id: string;
          lemon_squeezy_customer_id: string | null;
          lemon_squeezy_order_id: string | null;
          lemon_squeezy_subscription_id: string | null;
          plan_id: string | null;
          status: string;
          updated_at: string;
          user_email: string;
          user_id: string | null;
          variant_id: string | null;
        };
        Insert: {
          cancelled_at?: string | null;
          created_at?: string;
          current_period_end?: string | null;
          current_period_start?: string | null;
          id?: string;
          lemon_squeezy_customer_id?: string | null;
          lemon_squeezy_order_id?: string | null;
          lemon_squeezy_subscription_id?: string | null;
          plan_id?: string | null;
          status?: string;
          updated_at?: string;
          user_email: string;
          user_id?: string | null;
          variant_id?: string | null;
        };
        Update: {
          cancelled_at?: string | null;
          created_at?: string;
          current_period_end?: string | null;
          current_period_start?: string | null;
          id?: string;
          lemon_squeezy_customer_id?: string | null;
          lemon_squeezy_order_id?: string | null;
          lemon_squeezy_subscription_id?: string | null;
          plan_id?: string | null;
          status?: string;
          updated_at?: string;
          user_email?: string;
          user_id?: string | null;
          variant_id?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: "subscriptions_plan_id_fkey";
            columns: ["plan_id"];
            isOneToOne: false;
            referencedRelation: "plans";
            referencedColumns: ["id"];
          },
        ];
      };
      user_roles: {
        Row: {
          created_at: string;
          id: string;
          role: Database["public"]["Enums"]["app_role"];
          user_id: string;
        };
        Insert: {
          created_at?: string;
          id?: string;
          role: Database["public"]["Enums"]["app_role"];
          user_id: string;
        };
        Update: {
          created_at?: string;
          id?: string;
          role?: Database["public"]["Enums"]["app_role"];
          user_id?: string;
        };
        Relationships: [];
      };
      user_test_sessions: {
        Row: {
          answers: Json | null;
          attempt_number: number;
          completed_at: string | null;
          created_at: string;
          feedback_data: Json | null;
          id: string;
          last_active_at: string;
          progress_percent: number;
          score_band: number | null;
          started_at: string;
          status: string;
          test_id: string;
          test_type: string;
          user_id: string;
        };
        Insert: {
          answers?: Json | null;
          attempt_number?: number;
          completed_at?: string | null;
          created_at?: string;
          feedback_data?: Json | null;
          id?: string;
          last_active_at?: string;
          progress_percent?: number;
          score_band?: number | null;
          started_at?: string;
          status?: string;
          test_id: string;
          test_type: string;
          user_id: string;
        };
        Update: {
          answers?: Json | null;
          attempt_number?: number;
          completed_at?: string | null;
          created_at?: string;
          feedback_data?: Json | null;
          id?: string;
          last_active_at?: string;
          progress_percent?: number;
          score_band?: number | null;
          started_at?: string;
          status?: string;
          test_id?: string;
          test_type?: string;
          user_id?: string;
        };
        Relationships: [];
      };
      writing_tasks: {
        Row: {
          created_at: string;
          difficulty: string;
          id: string;
          image_url: string | null;
          include_model_answer: boolean;
          max_words: string | null;
          min_words: number;
          model_answer: string | null;
          prompt: string;
          suggested_time: string;
          task_number: number;
          task_type: string;
          test_id: string;
          title: string;
        };
        Insert: {
          created_at?: string;
          difficulty?: string;
          id?: string;
          image_url?: string | null;
          include_model_answer?: boolean;
          max_words?: string | null;
          min_words?: number;
          model_answer?: string | null;
          prompt?: string;
          suggested_time?: string;
          task_number?: number;
          task_type?: string;
          test_id: string;
          title?: string;
        };
        Update: {
          created_at?: string;
          difficulty?: string;
          id?: string;
          image_url?: string | null;
          include_model_answer?: boolean;
          max_words?: string | null;
          min_words?: number;
          model_answer?: string | null;
          prompt?: string;
          suggested_time?: string;
          task_number?: number;
          task_type?: string;
          test_id?: string;
          title?: string;
        };
        Relationships: [
          {
            foreignKeyName: "writing_tasks_test_id_fkey";
            columns: ["test_id"];
            isOneToOne: false;
            referencedRelation: "writing_tests";
            referencedColumns: ["id"];
          },
        ];
      };
      writing_tests: {
        Row: {
          created_at: string;
          created_by: string;
          id: string;
          status: string;
          title: string;
          updated_at: string;
        };
        Insert: {
          created_at?: string;
          created_by: string;
          id?: string;
          status?: string;
          title?: string;
          updated_at?: string;
        };
        Update: {
          created_at?: string;
          created_by?: string;
          id?: string;
          status?: string;
          title?: string;
          updated_at?: string;
        };
        Relationships: [];
      };
    };
    Views: {
      [_ in never]: never;
    };
    Functions: {
      has_role: {
        Args: {
          _role: Database["public"]["Enums"]["app_role"];
          _user_id: string;
        };
        Returns: boolean;
      };
    };
    Enums: {
      app_role: "student" | "super_admin";
    };
    CompositeTypes: {
      [_ in never]: never;
    };
  };
};

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">;

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">];

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R;
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] & DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R;
      }
      ? R
      : never
    : never;

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"] | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I;
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I;
      }
      ? I
      : never
    : never;

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"] | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U;
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U;
      }
      ? U
      : never
    : never;

export type Enums<
  DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"] | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never;

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never;

export const Constants = {
  public: {
    Enums: {
      app_role: ["student", "super_admin"],
    },
  },
} as const;
