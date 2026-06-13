-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "citext";

-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- CreateEnum
CREATE TYPE "InstituteStatus" AS ENUM ('ACTIVE', 'SUSPENDED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "OrgUnitStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('PENDING_VERIFICATION', 'ACTIVE', 'SUSPENDED', 'LOCKED', 'DEACTIVATED');

-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY');

-- CreateEnum
CREATE TYPE "RoleKind" AS ENUM ('SYSTEM', 'CUSTOM');

-- CreateEnum
CREATE TYPE "ScopeType" AS ENUM ('GLOBAL', 'INSTITUTE', 'CAMPUS', 'SCHOOL', 'DEPARTMENT', 'SELF');

-- CreateEnum
CREATE TYPE "MfaType" AS ENUM ('TOTP', 'SMS', 'EMAIL', 'WEBAUTHN', 'BACKUP_CODE');

-- CreateEnum
CREATE TYPE "MfaStatus" AS ENUM ('PENDING', 'ACTIVE', 'REVOKED');

-- CreateEnum
CREATE TYPE "SessionStatus" AS ENUM ('ACTIVE', 'REVOKED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "LoginResult" AS ENUM ('SUCCESS', 'INVALID_CREDENTIALS', 'MFA_REQUIRED', 'MFA_FAILED', 'ACCOUNT_LOCKED', 'ACCOUNT_DISABLED', 'RATE_LIMITED', 'UNKNOWN_USER');

-- CreateEnum
CREATE TYPE "SecurityEventType" AS ENUM ('SUSPICIOUS_LOGIN', 'IMPOSSIBLE_TRAVEL', 'PASSWORD_CHANGED', 'PASSWORD_RESET_REQUESTED', 'MFA_ENABLED', 'MFA_DISABLED', 'ROLE_GRANTED', 'ROLE_REVOKED', 'PERMISSION_GRANTED', 'PERMISSION_REVOKED', 'SCOPE_CHANGED', 'ACCOUNT_LOCKED', 'ACCOUNT_UNLOCKED', 'SESSION_REVOKED', 'API_KEY_CREATED', 'API_KEY_REVOKED', 'DATA_EXPORT', 'PRIVILEGED_ACTION');

-- CreateEnum
CREATE TYPE "SecuritySeverity" AS ENUM ('INFO', 'LOW', 'MEDIUM', 'HIGH', 'CRITICAL');

-- CreateEnum
CREATE TYPE "AuditAction" AS ENUM ('CREATE', 'READ', 'UPDATE', 'DELETE', 'RESTORE', 'APPROVE', 'REJECT', 'PUBLISH', 'UNPUBLISH', 'LOCK', 'UNLOCK', 'LOGIN', 'LOGOUT', 'EXPORT', 'IMPORT', 'ASSIGN', 'UNASSIGN', 'EXECUTE');

-- CreateEnum
CREATE TYPE "WorkflowStatus" AS ENUM ('DRAFT', 'PENDING', 'IN_PROGRESS', 'APPROVED', 'REJECTED', 'RETURNED', 'CANCELLED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "WorkflowActionType" AS ENUM ('SUBMIT', 'APPROVE', 'REJECT', 'RETURN', 'REASSIGN', 'COMMENT', 'CANCEL', 'ESCALATE');

-- CreateEnum
CREATE TYPE "NotificationChannel" AS ENUM ('IN_APP', 'EMAIL', 'SMS', 'PUSH', 'WHATSAPP');

-- CreateEnum
CREATE TYPE "NotificationStatus" AS ENUM ('QUEUED', 'SENDING', 'SENT', 'DELIVERED', 'READ', 'FAILED', 'BOUNCED');

-- CreateEnum
CREATE TYPE "NotificationPriority" AS ENUM ('LOW', 'NORMAL', 'HIGH', 'URGENT');

-- CreateEnum
CREATE TYPE "FileScanStatus" AS ENUM ('PENDING', 'CLEAN', 'INFECTED', 'ERROR', 'SKIPPED');

-- CreateEnum
CREATE TYPE "FileVisibility" AS ENUM ('PRIVATE', 'INSTITUTE', 'PUBLIC');

-- CreateEnum
CREATE TYPE "SettingScopeType" AS ENUM ('GLOBAL', 'INSTITUTE', 'CAMPUS', 'SCHOOL', 'DEPARTMENT', 'USER');

-- CreateEnum
CREATE TYPE "SettingValueType" AS ENUM ('STRING', 'NUMBER', 'BOOLEAN', 'JSON', 'SECRET');

-- CreateEnum
CREATE TYPE "AcademicYearStatus" AS ENUM ('PLANNED', 'ACTIVE', 'CLOSED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "TermType" AS ENUM ('SEMESTER', 'TRIMESTER', 'QUARTER', 'ANNUAL', 'SUMMER', 'WINTER');

-- CreateEnum
CREATE TYPE "TermStatus" AS ENUM ('PLANNED', 'REGISTRATION_OPEN', 'ACTIVE', 'EXAMS', 'RESULTS', 'CLOSED');

-- CreateEnum
CREATE TYPE "ProgramLevel" AS ENUM ('CERTIFICATE', 'DIPLOMA', 'UG', 'PG', 'DOCTORAL', 'POSTDOC');

-- CreateEnum
CREATE TYPE "ProgramMode" AS ENUM ('FULL_TIME', 'PART_TIME', 'DISTANCE', 'ONLINE', 'HYBRID');

-- CreateEnum
CREATE TYPE "ProgramStatus" AS ENUM ('DRAFT', 'ACTIVE', 'SUSPENDED', 'RETIRED');

-- CreateEnum
CREATE TYPE "BatchStatus" AS ENUM ('UPCOMING', 'ACTIVE', 'GRADUATED', 'DISCONTINUED');

-- CreateEnum
CREATE TYPE "SectionStatus" AS ENUM ('PLANNED', 'OPEN', 'LOCKED', 'CLOSED');

-- CreateEnum
CREATE TYPE "SubjectType" AS ENUM ('CORE', 'ELECTIVE', 'OPEN_ELECTIVE', 'AUDIT', 'LAB', 'PROJECT', 'SEMINAR', 'INTERNSHIP', 'THESIS', 'SKILL', 'VALUE_ADDED');

-- CreateEnum
CREATE TYPE "AssessmentScheme" AS ENUM ('THEORY', 'PRACTICAL', 'THEORY_PRACTICAL', 'PROJECT', 'CONTINUOUS');

-- CreateEnum
CREATE TYPE "GradingScheme" AS ENUM ('ABSOLUTE', 'RELATIVE', 'PASS_FAIL', 'LETTER_GRADE', 'CGPA_10', 'GPA_4', 'PERCENTAGE');

-- CreateEnum
CREATE TYPE "SubjectOfferingStatus" AS ENUM ('DRAFT', 'OPEN', 'CLOSED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "FacultyStatus" AS ENUM ('ACTIVE', 'ON_LEAVE', 'SABBATICAL', 'SUSPENDED', 'RETIRED', 'RESIGNED', 'TERMINATED');

-- CreateEnum
CREATE TYPE "FacultyDesignation" AS ENUM ('PROFESSOR', 'ASSOCIATE_PROFESSOR', 'ASSISTANT_PROFESSOR', 'LECTURER', 'SENIOR_LECTURER', 'VISITING_FACULTY', 'ADJUNCT', 'EMERITUS', 'RESEARCH_FELLOW', 'TEACHING_ASSISTANT');

-- CreateEnum
CREATE TYPE "EmploymentType" AS ENUM ('PERMANENT', 'CONTRACT', 'VISITING', 'GUEST', 'ADJUNCT', 'PROBATION');

-- CreateEnum
CREATE TYPE "FacultyAssignmentRole" AS ENUM ('PRIMARY_INSTRUCTOR', 'CO_INSTRUCTOR', 'LAB_INSTRUCTOR', 'TUTOR', 'GUEST_LECTURER', 'EXAMINER', 'MODERATOR', 'COORDINATOR');

-- CreateEnum
CREATE TYPE "FacultyAssignmentStatus" AS ENUM ('PROPOSED', 'APPROVED', 'ACTIVE', 'COMPLETED', 'WITHDRAWN', 'REJECTED');

-- CreateEnum
CREATE TYPE "MentorshipType" AS ENUM ('ACADEMIC', 'PROJECT', 'RESEARCH', 'CAREER', 'WELLBEING', 'THESIS', 'INTERNSHIP');

-- CreateEnum
CREATE TYPE "MentorshipStatus" AS ENUM ('REQUESTED', 'ACTIVE', 'PAUSED', 'COMPLETED', 'TERMINATED');

-- CreateEnum
CREATE TYPE "AdvisorRole" AS ENUM ('PRIMARY_ADVISOR', 'CO_ADVISOR', 'THESIS_ADVISOR', 'PROGRAM_ADVISOR', 'CLUB_ADVISOR');

-- CreateEnum
CREATE TYPE "AdvisorAssignmentStatus" AS ENUM ('ACTIVE', 'TRANSFERRED', 'COMPLETED', 'REVOKED');

-- CreateEnum
CREATE TYPE "room_type" AS ENUM ('CLASSROOM', 'LECTURE_HALL', 'SEMINAR_ROOM', 'AUDITORIUM', 'OFFICE', 'MEETING_ROOM', 'OTHER');

-- CreateEnum
CREATE TYPE "lab_type" AS ENUM ('COMPUTER_LAB', 'PHYSICS_LAB', 'CHEMISTRY_LAB', 'BIOLOGY_LAB', 'ELECTRONICS_LAB', 'MECHANICAL_LAB', 'LANGUAGE_LAB', 'RESEARCH_LAB', 'OTHER');

-- CreateEnum
CREATE TYPE "day_of_week" AS ENUM ('MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN');

-- CreateEnum
CREATE TYPE "timetable_status" AS ENUM ('DRAFT', 'PUBLISHED', 'ARCHIVED', 'SUPERSEDED');

-- CreateEnum
CREATE TYPE "timetable_entry_type" AS ENUM ('LECTURE', 'TUTORIAL', 'LAB', 'SEMINAR', 'PROJECT', 'MENTORING', 'EXAM', 'OTHER');

-- CreateEnum
CREATE TYPE "class_session_status" AS ENUM ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'RESCHEDULED', 'NO_SHOW');

-- CreateEnum
CREATE TYPE "delivery_mode" AS ENUM ('OFFLINE', 'ONLINE', 'HYBRID');

-- CreateEnum
CREATE TYPE "course_status" AS ENUM ('DRAFT', 'PUBLISHED', 'ARCHIVED', 'CLOSED');

-- CreateEnum
CREATE TYPE "course_enrollment_status" AS ENUM ('ENROLLED', 'ACTIVE', 'COMPLETED', 'DROPPED', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "module_status" AS ENUM ('DRAFT', 'PUBLISHED', 'LOCKED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "lms_session_type" AS ENUM ('LIVE_CLASS', 'RECORDED_LECTURE', 'READING', 'ACTIVITY', 'DISCUSSION', 'ASSESSMENT');

-- CreateEnum
CREATE TYPE "resource_type" AS ENUM ('PDF', 'VIDEO', 'AUDIO', 'LINK', 'SLIDES', 'DOCUMENT', 'IMAGE', 'CODE', 'DATASET', 'OTHER');

-- CreateEnum
CREATE TYPE "discussion_thread_status" AS ENUM ('OPEN', 'CLOSED', 'PINNED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "attendance_method" AS ENUM ('MANUAL', 'QR_CODE', 'BIOMETRIC', 'RFID', 'GEO_FENCE', 'FACE_RECOGNITION', 'OTP');

-- CreateEnum
CREATE TYPE "attendance_session_status" AS ENUM ('OPEN', 'CLOSED', 'LOCKED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "attendance_status" AS ENUM ('PRESENT', 'ABSENT', 'LATE', 'EXCUSED', 'ON_LEAVE', 'ON_DUTY');

-- CreateEnum
CREATE TYPE "assignment_type" AS ENUM ('HOMEWORK', 'PROJECT', 'ESSAY', 'CASE_STUDY', 'PRESENTATION', 'LAB_REPORT', 'GROUP', 'OTHER');

-- CreateEnum
CREATE TYPE "assignment_status" AS ENUM ('DRAFT', 'PUBLISHED', 'CLOSED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "submission_status" AS ENUM ('NOT_STARTED', 'DRAFT', 'SUBMITTED', 'LATE_SUBMITTED', 'GRADED', 'RETURNED', 'RESUBMITTED');

-- CreateEnum
CREATE TYPE "quiz_question_type" AS ENUM ('MCQ_SINGLE', 'MCQ_MULTI', 'TRUE_FALSE', 'SHORT_ANSWER', 'LONG_ANSWER', 'NUMERIC', 'FILL_BLANK', 'MATCHING', 'CODE');

-- CreateEnum
CREATE TYPE "quiz_difficulty" AS ENUM ('EASY', 'MEDIUM', 'HARD', 'EXPERT');

-- CreateEnum
CREATE TYPE "quiz_attempt_status" AS ENUM ('IN_PROGRESS', 'SUBMITTED', 'AUTO_SUBMITTED', 'GRADED', 'ABANDONED');

-- CreateEnum
CREATE TYPE "exam_type" AS ENUM ('INTERNAL_1', 'INTERNAL_2', 'MID_TERM', 'END_TERM', 'PRACTICAL', 'VIVA', 'PROJECT', 'SUPPLEMENTARY', 'REVALUATION');

-- CreateEnum
CREATE TYPE "exam_status" AS ENUM ('PLANNED', 'SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'RESULTS_PUBLISHED');

-- CreateEnum
CREATE TYPE "exam_schedule_status" AS ENUM ('SCHEDULED', 'ONGOING', 'COMPLETED', 'CANCELLED', 'RESCHEDULED');

-- CreateEnum
CREATE TYPE "hall_ticket_status" AS ENUM ('GENERATED', 'ISSUED', 'DOWNLOADED', 'REVOKED');

-- CreateEnum
CREATE TYPE "marks_entry_status" AS ENUM ('DRAFT', 'SUBMITTED', 'UNDER_MODERATION', 'MODERATED', 'APPROVED', 'REJECTED', 'PUBLISHED');

-- CreateEnum
CREATE TYPE "result_status" AS ENUM ('COMPUTED', 'PROVISIONAL', 'PUBLISHED', 'WITHHELD', 'REVISED');

-- CreateEnum
CREATE TYPE "result_grade_outcome" AS ENUM ('PASS', 'FAIL', 'PENDING', 'ABSENT', 'DEBARRED', 'MALPRACTICE');

-- CreateEnum
CREATE TYPE "revaluation_status" AS ENUM ('REQUESTED', 'PAYMENT_PENDING', 'IN_REVIEW', 'COMPLETED', 'REJECTED', 'WITHDRAWN');

-- CreateEnum
CREATE TYPE "invigilation_role" AS ENUM ('CHIEF', 'ASSISTANT', 'RELIEVER', 'SQUAD');

-- CreateEnum
CREATE TYPE "registration_cycle_status" AS ENUM ('PLANNED', 'OPEN', 'CLOSED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "course_registration_status" AS ENUM ('DRAFT', 'SUBMITTED', 'ADVISOR_APPROVED', 'HOD_APPROVED', 'REGISTERED', 'REJECTED', 'WITHDRAWN');

-- CreateEnum
CREATE TYPE "registration_subject_status" AS ENUM ('ADDED', 'DROPPED', 'WAITLISTED', 'CONFIRMED', 'AUDIT', 'WITHDRAWN');

-- CreateEnum
CREATE TYPE "fee_structure_status" AS ENUM ('DRAFT', 'ACTIVE', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "invoice_status" AS ENUM ('DRAFT', 'ISSUED', 'PARTIALLY_PAID', 'PAID', 'OVERDUE', 'CANCELLED', 'REFUNDED', 'WRITTEN_OFF');

-- CreateEnum
CREATE TYPE "payment_method" AS ENUM ('CASH', 'CARD', 'UPI', 'NET_BANKING', 'WALLET', 'CHEQUE', 'DEMAND_DRAFT', 'BANK_TRANSFER', 'SCHOLARSHIP', 'WAIVER', 'ADJUSTMENT');

-- CreateEnum
CREATE TYPE "payment_status" AS ENUM ('INITIATED', 'PENDING', 'SUCCESS', 'FAILED', 'REFUNDED', 'CHARGEBACK', 'CANCELLED');

-- CreateEnum
CREATE TYPE "scholarship_status" AS ENUM ('APPLIED', 'UNDER_REVIEW', 'APPROVED', 'REJECTED', 'DISBURSED', 'REVOKED');

-- CreateEnum
CREATE TYPE "wallet_status" AS ENUM ('ACTIVE', 'FROZEN', 'CLOSED');

-- CreateEnum
CREATE TYPE "wallet_txn_type" AS ENUM ('CREDIT', 'DEBIT', 'HOLD', 'RELEASE', 'REFUND', 'ADJUSTMENT');

-- CreateEnum
CREATE TYPE "waiver_status" AS ENUM ('REQUESTED', 'APPROVED', 'REJECTED', 'APPLIED', 'REVOKED');

-- CreateEnum
CREATE TYPE "document_category" AS ENUM ('ACADEMIC', 'ADMINISTRATIVE', 'FINANCIAL', 'IDENTITY', 'MEDICAL', 'LEGAL', 'CIRCULAR', 'POLICY', 'OTHER');

-- CreateEnum
CREATE TYPE "certificate_type" AS ENUM ('BONAFIDE', 'CONDUCT', 'TRANSFER', 'MIGRATION', 'CHARACTER', 'COURSE_COMPLETION', 'PROVISIONAL', 'DEGREE', 'INTERNSHIP', 'RANK', 'PARTICIPATION', 'NOC', 'OTHER');

-- CreateEnum
CREATE TYPE "certificate_status" AS ENUM ('REQUESTED', 'IN_PROCESS', 'ISSUED', 'REJECTED', 'REVOKED');

-- CreateEnum
CREATE TYPE "ticket_category" AS ENUM ('ACADEMIC', 'FINANCE', 'HOSTEL', 'TRANSPORT', 'LIBRARY', 'EXAMS', 'IT', 'INFRASTRUCTURE', 'GRIEVANCE', 'OTHER');

-- CreateEnum
CREATE TYPE "ticket_priority" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'URGENT');

-- CreateEnum
CREATE TYPE "ticket_status" AS ENUM ('OPEN', 'IN_PROGRESS', 'ON_HOLD', 'RESOLVED', 'CLOSED', 'REOPENED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "book_status" AS ENUM ('AVAILABLE', 'ISSUED', 'RESERVED', 'LOST', 'DAMAGED', 'WITHDRAWN', 'UNDER_REPAIR');

-- CreateEnum
CREATE TYPE "book_issue_status" AS ENUM ('ISSUED', 'RETURNED', 'OVERDUE', 'LOST', 'RENEWED');

-- CreateEnum
CREATE TYPE "reservation_status" AS ENUM ('PENDING', 'READY', 'COLLECTED', 'CANCELLED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "hostel_type" AS ENUM ('BOYS', 'GIRLS', 'CO_ED', 'FACULTY', 'GUEST');

-- CreateEnum
CREATE TYPE "hostel_allocation_status" AS ENUM ('ALLOCATED', 'CHECKED_IN', 'CHECKED_OUT', 'VACATED', 'TRANSFERRED');

-- CreateEnum
CREATE TYPE "leave_request_status" AS ENUM ('REQUESTED', 'APPROVED', 'REJECTED', 'CANCELLED', 'COMPLETED');

-- CreateEnum
CREATE TYPE "transport_pass_status" AS ENUM ('ACTIVE', 'EXPIRED', 'CANCELLED', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "event_status" AS ENUM ('PLANNED', 'REGISTRATION_OPEN', 'REGISTRATION_CLOSED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "feedback_target_type" AS ENUM ('COURSE', 'FACULTY', 'SUBJECT_OFFERING', 'EVENT', 'INSTITUTE', 'HOSTEL', 'TRANSPORT', 'LIBRARY', 'OTHER');

-- CreateEnum
CREATE TYPE "company_status" AS ENUM ('ACTIVE', 'INACTIVE', 'BLACKLISTED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "company_size" AS ENUM ('STARTUP', 'SMALL', 'MEDIUM', 'LARGE', 'ENTERPRISE', 'MNC');

-- CreateEnum
CREATE TYPE "drive_type" AS ENUM ('ON_CAMPUS', 'OFF_CAMPUS', 'POOL', 'VIRTUAL', 'INTERNSHIP');

-- CreateEnum
CREATE TYPE "drive_status" AS ENUM ('PLANNED', 'ANNOUNCED', 'REGISTRATION_OPEN', 'REGISTRATION_CLOSED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "application_stage" AS ENUM ('APPLIED', 'SHORTLISTED', 'APTITUDE', 'TECHNICAL', 'GROUP_DISCUSSION', 'HR', 'OFFERED', 'REJECTED', 'WITHDRAWN', 'ON_HOLD');

-- CreateEnum
CREATE TYPE "offer_status" AS ENUM ('EXTENDED', 'ACCEPTED', 'DECLINED', 'REVOKED', 'EXPIRED', 'JOINED');

-- CreateEnum
CREATE TYPE "offer_type" AS ENUM ('FULL_TIME', 'INTERNSHIP', 'PPO', 'CONTRACT');

-- CreateEnum
CREATE TYPE "research_project_status" AS ENUM ('PROPOSED', 'APPROVED', 'IN_PROGRESS', 'ON_HOLD', 'COMPLETED', 'CLOSED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "publication_type" AS ENUM ('JOURNAL', 'CONFERENCE', 'BOOK', 'BOOK_CHAPTER', 'WORKSHOP', 'PREPRINT', 'TECHNICAL_REPORT', 'THESIS', 'OTHER');

-- CreateEnum
CREATE TYPE "grant_status" AS ENUM ('PROPOSED', 'SUBMITTED', 'UNDER_REVIEW', 'APPROVED', 'REJECTED', 'ACTIVE', 'COMPLETED', 'CLOSED');

-- CreateEnum
CREATE TYPE "patent_status" AS ENUM ('IDEA', 'DRAFTING', 'FILED', 'PUBLISHED', 'UNDER_EXAMINATION', 'GRANTED', 'REJECTED', 'ABANDONED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "IdempotencyState" AS ENUM ('in_flight', 'completed', 'failed');

-- CreateEnum
CREATE TYPE "FeatureRolloutType" AS ENUM ('global', 'per_institute', 'percentage', 'allowlist', 'blocklist');

-- CreateEnum
CREATE TYPE "EscalationState" AS ENUM ('scheduled', 'fired_l1', 'fired_l2', 'fired_l3', 'resolved', 'timed_out', 'cancelled');

-- CreateEnum
CREATE TYPE "OnlineExamMediaKind" AS ENUM ('webcam_snapshot', 'screen_snapshot', 'audio_clip', 'question_paper', 'response_pdf', 'proctor_flag');

-- CreateEnum
CREATE TYPE "NotificationProvider" AS ENUM ('smtp', 'ses', 'sendgrid', 'msg91', 'twilio', 'fcm', 'apns', 'whatsapp_cloud');

-- CreateTable
CREATE TABLE "institutes" (
    "id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "legal_name" TEXT,
    "domain" TEXT,
    "logo_file_id" UUID,
    "timezone" TEXT NOT NULL DEFAULT 'Asia/Kolkata',
    "locale" TEXT NOT NULL DEFAULT 'en-IN',
    "status" "InstituteStatus" NOT NULL DEFAULT 'ACTIVE',
    "contact_email" TEXT,
    "contact_phone" TEXT,
    "address_line1" TEXT,
    "address_line2" TEXT,
    "city" TEXT,
    "state" TEXT,
    "country" TEXT,
    "postal_code" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "institutes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campuses" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_main" BOOLEAN NOT NULL DEFAULT false,
    "address_line1" TEXT,
    "address_line2" TEXT,
    "city" TEXT,
    "state" TEXT,
    "country" TEXT,
    "postal_code" TEXT,
    "latitude" DECIMAL(10,7),
    "longitude" DECIMAL(10,7),
    "status" "OrgUnitStatus" NOT NULL DEFAULT 'ACTIVE',
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "campuses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "schools" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "campus_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "short_name" TEXT,
    "dean_user_id" UUID,
    "status" "OrgUnitStatus" NOT NULL DEFAULT 'ACTIVE',
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "schools_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "departments" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "campus_id" UUID NOT NULL,
    "school_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "short_name" TEXT,
    "hod_user_id" UUID,
    "status" "OrgUnitStatus" NOT NULL DEFAULT 'ACTIVE',
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "departments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "institute_id" UUID,
    "email" TEXT NOT NULL,
    "email_verified_at" TIMESTAMP(3),
    "phone" TEXT,
    "phone_verified_at" TIMESTAMP(3),
    "first_name" TEXT NOT NULL,
    "middle_name" TEXT,
    "last_name" TEXT NOT NULL,
    "display_name" TEXT,
    "gender" "Gender",
    "date_of_birth" DATE,
    "avatar_file_id" UUID,
    "status" "UserStatus" NOT NULL DEFAULT 'PENDING_VERIFICATION',
    "locked_until" TIMESTAMP(3),
    "failed_login_count" INTEGER NOT NULL DEFAULT 0,
    "last_login_at" TIMESTAMP(3),
    "last_login_ip" TEXT,
    "mfa_enabled" BOOLEAN NOT NULL DEFAULT false,
    "must_change_password" BOOLEAN NOT NULL DEFAULT false,
    "preferred_language" TEXT NOT NULL DEFAULT 'en',
    "timezone" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" UUID NOT NULL,
    "institute_id" UUID,
    "key" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "kind" "RoleKind" NOT NULL DEFAULT 'SYSTEM',
    "default_scope" "ScopeType" NOT NULL DEFAULT 'INSTITUTE',
    "rank" INTEGER NOT NULL DEFAULT 100,
    "is_assignable" BOOLEAN NOT NULL DEFAULT true,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permissions" (
    "id" UUID NOT NULL,
    "key" TEXT NOT NULL,
    "module" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "description" TEXT,
    "is_sensitive" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role_permissions" (
    "role_id" UUID NOT NULL,
    "permission_id" UUID NOT NULL,
    "granted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "role_permissions_pkey" PRIMARY KEY ("role_id","permission_id")
);

-- CreateTable
CREATE TABLE "user_roles" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "role_id" UUID NOT NULL,
    "scope_type" "ScopeType" NOT NULL,
    "scope_id" UUID,
    "institute_id" UUID,
    "is_primary" BOOLEAN NOT NULL DEFAULT false,
    "valid_from" TIMESTAMP(3),
    "valid_until" TIMESTAMP(3),
    "granted_by_id" UUID,
    "grant_reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "user_roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_scopes" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "scope_type" "ScopeType" NOT NULL,
    "scope_id" UUID,
    "institute_id" UUID,
    "reason" TEXT,
    "valid_from" TIMESTAMP(3),
    "valid_until" TIMESTAMP(3),
    "granted_by_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "user_scopes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "auth_credentials" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "password_hash" TEXT NOT NULL,
    "algorithm" TEXT NOT NULL DEFAULT 'argon2id',
    "rotated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3),
    "is_current" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "auth_credentials_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sessions" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "refresh_token_hash" TEXT NOT NULL,
    "refresh_family_id" UUID NOT NULL,
    "device_id" TEXT,
    "device_name" TEXT,
    "user_agent" TEXT,
    "ip_address" TEXT,
    "geo_country" TEXT,
    "geo_city" TEXT,
    "status" "SessionStatus" NOT NULL DEFAULT 'ACTIVE',
    "issued_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "last_seen_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "revoked_at" TIMESTAMP(3),
    "revoked_reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "login_attempts" (
    "id" UUID NOT NULL,
    "user_id" UUID,
    "email_tried" TEXT,
    "result" "LoginResult" NOT NULL,
    "reason" TEXT,
    "ip_address" TEXT,
    "user_agent" TEXT,
    "geo_country" TEXT,
    "attempted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "login_attempts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mfa_factors" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "type" "MfaType" NOT NULL,
    "label" TEXT,
    "secret" TEXT,
    "phone_number" TEXT,
    "email" TEXT,
    "status" "MfaStatus" NOT NULL DEFAULT 'PENDING',
    "last_used_at" TIMESTAMP(3),
    "verified_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "mfa_factors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "password_reset_tokens" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "token_hash" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "consumed_at" TIMESTAMP(3),
    "request_ip" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "password_reset_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "email_verification_tokens" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "email" TEXT NOT NULL,
    "token_hash" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "consumed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "email_verification_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "security_events" (
    "id" UUID NOT NULL,
    "institute_id" UUID,
    "user_id" UUID,
    "event_type" "SecurityEventType" NOT NULL,
    "severity" "SecuritySeverity" NOT NULL DEFAULT 'INFO',
    "message" TEXT,
    "ip_address" TEXT,
    "user_agent" TEXT,
    "context" JSONB,
    "occurred_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "security_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL,
    "institute_id" UUID,
    "actor_user_id" UUID,
    "actor_role_key" TEXT,
    "action" "AuditAction" NOT NULL,
    "entity_type" TEXT NOT NULL,
    "entity_id" UUID,
    "summary" TEXT,
    "before" JSONB,
    "after" JSONB,
    "diff" JSONB,
    "ip_address" TEXT,
    "user_agent" TEXT,
    "request_id" TEXT,
    "trace_id" TEXT,
    "occurred_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workflow_definitions" (
    "id" UUID NOT NULL,
    "institute_id" UUID,
    "key" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "entity_type" TEXT NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 1,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "config" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "workflow_definitions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workflow_steps" (
    "id" UUID NOT NULL,
    "workflow_id" UUID NOT NULL,
    "sequence" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "approver_role_key" TEXT NOT NULL,
    "approver_scope_type" "ScopeType" NOT NULL,
    "required_approvals" INTEGER NOT NULL DEFAULT 1,
    "sla_hours" INTEGER,
    "escalation_role_key" TEXT,
    "allow_reassign" BOOLEAN NOT NULL DEFAULT true,
    "allow_reject" BOOLEAN NOT NULL DEFAULT true,
    "allow_return" BOOLEAN NOT NULL DEFAULT true,
    "config" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "workflow_steps_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workflow_instances" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "workflow_id" UUID NOT NULL,
    "entity_type" TEXT NOT NULL,
    "entity_id" UUID NOT NULL,
    "initiator_user_id" UUID NOT NULL,
    "current_step" INTEGER NOT NULL DEFAULT 1,
    "status" "WorkflowStatus" NOT NULL DEFAULT 'PENDING',
    "context" JSONB,
    "due_at" TIMESTAMP(3),
    "completed_at" TIMESTAMP(3),
    "cancelled_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "workflow_instances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workflow_actions" (
    "id" UUID NOT NULL,
    "instance_id" UUID NOT NULL,
    "step_id" UUID,
    "step_sequence" INTEGER NOT NULL,
    "actor_user_id" UUID NOT NULL,
    "action_type" "WorkflowActionType" NOT NULL,
    "comment" TEXT,
    "attachments" JSONB,
    "metadata" JSONB,
    "performed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "workflow_actions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_templates" (
    "id" UUID NOT NULL,
    "institute_id" UUID,
    "key" TEXT NOT NULL,
    "channel" "NotificationChannel" NOT NULL,
    "locale" TEXT NOT NULL DEFAULT 'en',
    "subject" TEXT,
    "body" TEXT NOT NULL,
    "variables" JSONB,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "notification_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "recipient_id" UUID NOT NULL,
    "event_key" TEXT NOT NULL,
    "channel" "NotificationChannel" NOT NULL,
    "priority" "NotificationPriority" NOT NULL DEFAULT 'NORMAL',
    "status" "NotificationStatus" NOT NULL DEFAULT 'QUEUED',
    "subject" TEXT,
    "body" TEXT,
    "payload" JSONB,
    "related_entity_type" TEXT,
    "related_entity_id" UUID,
    "provider_message_id" TEXT,
    "error_message" TEXT,
    "scheduled_for" TIMESTAMP(3),
    "sent_at" TIMESTAMP(3),
    "delivered_at" TIMESTAMP(3),
    "read_at" TIMESTAMP(3),
    "failed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_preferences" (
    "user_id" UUID NOT NULL,
    "event_key" TEXT NOT NULL,
    "channel" "NotificationChannel" NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notification_preferences_pkey" PRIMARY KEY ("user_id","event_key","channel")
);

-- CreateTable
CREATE TABLE "file_objects" (
    "id" UUID NOT NULL,
    "institute_id" UUID,
    "bucket" TEXT NOT NULL,
    "storage_key" TEXT NOT NULL,
    "original_name" TEXT NOT NULL,
    "mime_type" TEXT NOT NULL,
    "size_bytes" BIGINT NOT NULL,
    "checksum_sha256" TEXT,
    "uploaded_by_id" UUID,
    "visibility" "FileVisibility" NOT NULL DEFAULT 'PRIVATE',
    "scan_status" "FileScanStatus" NOT NULL DEFAULT 'PENDING',
    "scan_result" JSONB,
    "related_entity_type" TEXT,
    "related_entity_id" UUID,
    "metadata" JSONB,
    "expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "file_objects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "file_access_grants" (
    "id" UUID NOT NULL,
    "file_id" UUID NOT NULL,
    "granted_to_id" UUID,
    "granted_by_id" UUID NOT NULL,
    "signed_url_hash" TEXT,
    "permission" TEXT NOT NULL DEFAULT 'READ',
    "expires_at" TIMESTAMP(3) NOT NULL,
    "revoked_at" TIMESTAMP(3),
    "access_count" INTEGER NOT NULL DEFAULT 0,
    "last_accessed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "file_access_grants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "settings" (
    "id" UUID NOT NULL,
    "scope_type" "SettingScopeType" NOT NULL,
    "scope_id" UUID,
    "category" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "value_type" "SettingValueType" NOT NULL,
    "value" JSONB NOT NULL,
    "is_secret" BOOLEAN NOT NULL DEFAULT false,
    "is_overridable" BOOLEAN NOT NULL DEFAULT true,
    "description" TEXT,
    "version" INTEGER NOT NULL DEFAULT 1,
    "updated_by_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "settings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "academic_years" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "status" "AcademicYearStatus" NOT NULL DEFAULT 'PLANNED',
    "is_current" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "academic_years_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "terms" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "academic_year_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "TermType" NOT NULL,
    "sequence" INTEGER NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "registration_start" TIMESTAMP(3),
    "registration_end" TIMESTAMP(3),
    "classes_start" DATE,
    "classes_end" DATE,
    "exams_start" DATE,
    "exams_end" DATE,
    "results_date" DATE,
    "status" "TermStatus" NOT NULL DEFAULT 'PLANNED',
    "is_current" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "terms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "programs" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "campus_id" UUID,
    "school_id" UUID NOT NULL,
    "department_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "short_name" TEXT,
    "level" "ProgramLevel" NOT NULL,
    "mode" "ProgramMode" NOT NULL DEFAULT 'FULL_TIME',
    "duration_years" DECIMAL(4,2) NOT NULL,
    "total_terms" INTEGER NOT NULL,
    "total_credits" INTEGER NOT NULL,
    "min_pass_credits" INTEGER,
    "grading_scheme" "GradingScheme" NOT NULL DEFAULT 'CGPA_10',
    "intake_capacity" INTEGER NOT NULL,
    "description" TEXT,
    "accreditation" TEXT,
    "effective_from" DATE NOT NULL,
    "effective_to" DATE,
    "status" "ProgramStatus" NOT NULL DEFAULT 'DRAFT',
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "programs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "batches" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "program_id" UUID NOT NULL,
    "academic_year_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "intake_year" INTEGER NOT NULL,
    "expected_grad_year" INTEGER NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "sanctioned_seats" INTEGER NOT NULL,
    "filled_seats" INTEGER NOT NULL DEFAULT 0,
    "current_term_seq" INTEGER,
    "status" "BatchStatus" NOT NULL DEFAULT 'UPCOMING',
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "batches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sections" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "batch_id" UUID NOT NULL,
    "term_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "capacity" INTEGER NOT NULL,
    "enrolled_count" INTEGER NOT NULL DEFAULT 0,
    "class_rep_user_id" UUID,
    "class_advisor_faculty_id" UUID,
    "room_hint" TEXT,
    "status" "SectionStatus" NOT NULL DEFAULT 'PLANNED',
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "sections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subjects" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "department_id" UUID NOT NULL,
    "program_id" UUID,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "short_name" TEXT,
    "type" "SubjectType" NOT NULL DEFAULT 'CORE',
    "term_sequence" INTEGER,
    "credits" DECIMAL(4,2) NOT NULL,
    "lecture_hours" INTEGER NOT NULL DEFAULT 0,
    "tutorial_hours" INTEGER NOT NULL DEFAULT 0,
    "practical_hours" INTEGER NOT NULL DEFAULT 0,
    "contact_hours_week" INTEGER,
    "assessment_scheme" "AssessmentScheme" NOT NULL DEFAULT 'THEORY',
    "grading_scheme" "GradingScheme" NOT NULL DEFAULT 'CGPA_10',
    "max_marks" INTEGER NOT NULL DEFAULT 100,
    "pass_marks" INTEGER NOT NULL DEFAULT 40,
    "internal_weight" INTEGER NOT NULL DEFAULT 40,
    "external_weight" INTEGER NOT NULL DEFAULT 60,
    "syllabus_file_id" UUID,
    "description" TEXT,
    "outcomes" JSONB,
    "effective_from" DATE NOT NULL,
    "effective_to" DATE,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "subjects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subject_prerequisites" (
    "subject_id" UUID NOT NULL,
    "prerequisite_id" UUID NOT NULL,
    "min_grade" TEXT,
    "is_mandatory" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "subject_prerequisites_pkey" PRIMARY KEY ("subject_id","prerequisite_id")
);

-- CreateTable
CREATE TABLE "subject_offerings" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "subject_id" UUID NOT NULL,
    "term_id" UUID NOT NULL,
    "section_id" UUID,
    "program_id" UUID,
    "department_id" UUID NOT NULL,
    "offering_code" TEXT NOT NULL,
    "capacity" INTEGER NOT NULL,
    "enrolled_count" INTEGER NOT NULL DEFAULT 0,
    "waitlist_count" INTEGER NOT NULL DEFAULT 0,
    "credits_override" DECIMAL(4,2),
    "grading_scheme" "GradingScheme",
    "registration_start" TIMESTAMP(3),
    "registration_end" TIMESTAMP(3),
    "status" "SubjectOfferingStatus" NOT NULL DEFAULT 'DRAFT',
    "syllabus_file_id" UUID,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "subject_offerings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "faculty" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "campus_id" UUID,
    "school_id" UUID NOT NULL,
    "department_id" UUID NOT NULL,
    "employee_code" TEXT NOT NULL,
    "designation" "FacultyDesignation" NOT NULL,
    "employment_type" "EmploymentType" NOT NULL DEFAULT 'PERMANENT',
    "join_date" DATE NOT NULL,
    "confirmation_date" DATE,
    "exit_date" DATE,
    "qualifications" JSONB,
    "specializations" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "research_areas" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "office_room" TEXT,
    "office_hours" JSONB,
    "weekly_load_hours" INTEGER,
    "max_weekly_load_hours" INTEGER,
    "reports_to_faculty_id" UUID,
    "is_hod" BOOLEAN NOT NULL DEFAULT false,
    "is_mentor" BOOLEAN NOT NULL DEFAULT false,
    "is_advisor" BOOLEAN NOT NULL DEFAULT false,
    "status" "FacultyStatus" NOT NULL DEFAULT 'ACTIVE',
    "biography" TEXT,
    "profile_photo_file_id" UUID,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "faculty_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "faculty_assignments" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "faculty_id" UUID NOT NULL,
    "subject_offering_id" UUID NOT NULL,
    "role" "FacultyAssignmentRole" NOT NULL DEFAULT 'PRIMARY_INSTRUCTOR',
    "load_hours_per_week" DECIMAL(5,2),
    "workload_units" DECIMAL(5,2),
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "status" "FacultyAssignmentStatus" NOT NULL DEFAULT 'PROPOSED',
    "assigned_by_user_id" UUID,
    "approved_by_user_id" UUID,
    "approved_at" TIMESTAMP(3),
    "remarks" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "faculty_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mentorships" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "mentor_faculty_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "type" "MentorshipType" NOT NULL DEFAULT 'ACADEMIC',
    "academic_year_id" UUID,
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "status" "MentorshipStatus" NOT NULL DEFAULT 'REQUESTED',
    "goals" TEXT,
    "meeting_cadence" TEXT,
    "last_interaction_at" TIMESTAMP(3),
    "interaction_count" INTEGER NOT NULL DEFAULT 0,
    "rating" DECIMAL(3,2),
    "feedback" TEXT,
    "assigned_by_user_id" UUID,
    "closed_reason" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "mentorships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "faculty_advisors" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "faculty_id" UUID NOT NULL,
    "role" "AdvisorRole" NOT NULL DEFAULT 'PROGRAM_ADVISOR',
    "scope_type" TEXT NOT NULL,
    "scope_id" UUID NOT NULL,
    "academic_year_id" UUID,
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "status" "AdvisorAssignmentStatus" NOT NULL DEFAULT 'ACTIVE',
    "assigned_by_user_id" UUID,
    "remarks" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "faculty_advisors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "advisor_students" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "faculty_advisor_id" UUID NOT NULL,
    "advisor_faculty_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "role" "AdvisorRole" NOT NULL DEFAULT 'PROGRAM_ADVISOR',
    "academic_year_id" UUID,
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "status" "AdvisorAssignmentStatus" NOT NULL DEFAULT 'ACTIVE',
    "notes" TEXT,
    "assigned_by_user_id" UUID,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "advisor_students_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "students" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "enrollment_no" TEXT NOT NULL,
    "roll_no" TEXT,
    "program_id" UUID NOT NULL,
    "batch_id" UUID NOT NULL,
    "section_id" UUID,
    "admission_date" DATE NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "students_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rooms" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "campus_id" UUID,
    "building" VARCHAR(64),
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "room_type" NOT NULL,
    "capacity" INTEGER NOT NULL,
    "floor" INTEGER,
    "has_projector" BOOLEAN NOT NULL DEFAULT false,
    "has_ac" BOOLEAN NOT NULL DEFAULT false,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "rooms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "labs" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "campus_id" UUID,
    "building" VARCHAR(64),
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "lab_type" NOT NULL,
    "capacity" INTEGER NOT NULL,
    "equipment" JSONB,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "labs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "time_slots" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "start_time" TEXT NOT NULL,
    "end_time" TEXT NOT NULL,
    "duration_min" INTEGER NOT NULL,
    "slot_order" INTEGER NOT NULL,
    "is_break" BOOLEAN NOT NULL DEFAULT false,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "time_slots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "timetables" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "term_id" UUID NOT NULL,
    "section_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "effective_from" DATE NOT NULL,
    "effective_to" DATE,
    "status" "timetable_status" NOT NULL DEFAULT 'DRAFT',
    "version" INTEGER NOT NULL DEFAULT 1,
    "published_at" TIMESTAMP(3),
    "published_by_id" UUID,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "timetables_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "timetable_entries" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "timetable_id" UUID NOT NULL,
    "subject_offering_id" UUID NOT NULL,
    "faculty_assignment_id" UUID,
    "primary_faculty_id" UUID NOT NULL,
    "day_of_week" "day_of_week" NOT NULL,
    "time_slot_id" UUID NOT NULL,
    "room_id" UUID,
    "lab_id" UUID,
    "entry_type" "timetable_entry_type" NOT NULL,
    "delivery_mode" "delivery_mode" NOT NULL DEFAULT 'OFFLINE',
    "meeting_url" TEXT,
    "week_parity" TEXT,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "timetable_entries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_sessions" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "timetable_entry_id" UUID,
    "subject_offering_id" UUID NOT NULL,
    "faculty_id" UUID NOT NULL,
    "section_id" UUID NOT NULL,
    "room_id" UUID,
    "lab_id" UUID,
    "session_date" DATE NOT NULL,
    "start_at" TIMESTAMP(3) NOT NULL,
    "end_at" TIMESTAMP(3) NOT NULL,
    "entry_type" "timetable_entry_type" NOT NULL,
    "delivery_mode" "delivery_mode" NOT NULL DEFAULT 'OFFLINE',
    "status" "class_session_status" NOT NULL DEFAULT 'SCHEDULED',
    "topic" TEXT,
    "summary" TEXT,
    "cancellation_reason" TEXT,
    "rescheduled_to_id" UUID,
    "meeting_url" TEXT,
    "meeting_recording_url" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "class_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "faculty_workloads" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "faculty_id" UUID NOT NULL,
    "term_id" UUID NOT NULL,
    "lecture_hours_planned" DECIMAL(8,2) NOT NULL DEFAULT 0,
    "lab_hours_planned" DECIMAL(8,2) NOT NULL DEFAULT 0,
    "tutorial_hours_planned" DECIMAL(8,2) NOT NULL DEFAULT 0,
    "other_hours_planned" DECIMAL(8,2) NOT NULL DEFAULT 0,
    "total_hours_planned" DECIMAL(8,2) NOT NULL DEFAULT 0,
    "lecture_hours_actual" DECIMAL(8,2) NOT NULL DEFAULT 0,
    "lab_hours_actual" DECIMAL(8,2) NOT NULL DEFAULT 0,
    "tutorial_hours_actual" DECIMAL(8,2) NOT NULL DEFAULT 0,
    "other_hours_actual" DECIMAL(8,2) NOT NULL DEFAULT 0,
    "total_hours_actual" DECIMAL(8,2) NOT NULL DEFAULT 0,
    "max_hours_allowed" DECIMAL(8,2),
    "notes" TEXT,
    "last_recalculated_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "faculty_workloads_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "courses" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "subject_offering_id" UUID,
    "term_id" UUID,
    "owner_faculty_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "cover_image_url" TEXT,
    "status" "course_status" NOT NULL DEFAULT 'DRAFT',
    "is_self_paced" BOOLEAN NOT NULL DEFAULT false,
    "starts_at" TIMESTAMP(3),
    "ends_at" TIMESTAMP(3),
    "syllabus_url" TEXT,
    "estimated_hours" DECIMAL(6,2),
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "courses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "course_enrollments" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "course_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "enrolled_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed_at" TIMESTAMP(3),
    "status" "course_enrollment_status" NOT NULL DEFAULT 'ENROLLED',
    "progress_pct" DECIMAL(5,2) NOT NULL DEFAULT 0,
    "last_accessed_at" TIMESTAMP(3),
    "grade" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "course_enrollments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "course_modules" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "course_id" UUID NOT NULL,
    "parent_id" UUID,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "order_index" INTEGER NOT NULL,
    "status" "module_status" NOT NULL DEFAULT 'DRAFT',
    "unlocks_at" TIMESTAMP(3),
    "locks_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "course_modules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lms_sessions" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "module_id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "type" "lms_session_type" NOT NULL,
    "order_index" INTEGER NOT NULL,
    "duration_min" INTEGER,
    "scheduled_at" TIMESTAMP(3),
    "meeting_url" TEXT,
    "recording_url" TEXT,
    "content_markdown" TEXT,
    "is_mandatory" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "lms_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "resources" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "course_id" UUID,
    "module_id" UUID,
    "session_id" UUID,
    "title" TEXT NOT NULL,
    "type" "resource_type" NOT NULL,
    "url" TEXT,
    "file_object_id" UUID,
    "size_bytes" BIGINT,
    "mime_type" TEXT,
    "description" TEXT,
    "is_downloadable" BOOLEAN NOT NULL DEFAULT true,
    "order_index" INTEGER NOT NULL DEFAULT 0,
    "created_by_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "resources_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "discussion_threads" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "course_id" UUID NOT NULL,
    "author_user_id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "status" "discussion_thread_status" NOT NULL DEFAULT 'OPEN',
    "is_announcement" BOOLEAN NOT NULL DEFAULT false,
    "view_count" INTEGER NOT NULL DEFAULT 0,
    "last_activity_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "discussion_threads_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "discussion_comments" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "thread_id" UUID NOT NULL,
    "parent_id" UUID,
    "author_user_id" UUID NOT NULL,
    "body" TEXT NOT NULL,
    "is_answer" BOOLEAN NOT NULL DEFAULT false,
    "upvotes" INTEGER NOT NULL DEFAULT 0,
    "edited_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "discussion_comments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attendance_sessions" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "class_session_id" UUID NOT NULL,
    "subject_offering_id" UUID NOT NULL,
    "section_id" UUID NOT NULL,
    "faculty_id" UUID NOT NULL,
    "session_date" DATE NOT NULL,
    "opened_at" TIMESTAMP(3),
    "closed_at" TIMESTAMP(3),
    "method" "attendance_method" NOT NULL DEFAULT 'MANUAL',
    "status" "attendance_session_status" NOT NULL DEFAULT 'OPEN',
    "qr_token" TEXT,
    "qr_expires_at" TIMESTAMP(3),
    "geo_lat" DECIMAL(10,7),
    "geo_lng" DECIMAL(10,7),
    "geo_radius_m" INTEGER,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "attendance_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attendance_records" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "attendance_session_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "status" "attendance_status" NOT NULL,
    "marked_at" TIMESTAMP(3),
    "marked_by_user_id" UUID,
    "method" "attendance_method",
    "remark" TEXT,
    "geo_lat" DECIMAL(10,7),
    "geo_lng" DECIMAL(10,7),
    "device_fingerprint" TEXT,
    "ip_address" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "attendance_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assignment_categories" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "subject_offering_id" UUID,
    "course_id" UUID,
    "name" TEXT NOT NULL,
    "weight_pct" DECIMAL(5,2) NOT NULL DEFAULT 0,
    "description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "assignment_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assignments" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "course_id" UUID,
    "subject_offering_id" UUID,
    "category_id" UUID,
    "created_by_faculty_id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "type" "assignment_type" NOT NULL DEFAULT 'HOMEWORK',
    "status" "assignment_status" NOT NULL DEFAULT 'DRAFT',
    "max_marks" DECIMAL(8,2) NOT NULL,
    "weight_pct" DECIMAL(5,2),
    "published_at" TIMESTAMP(3),
    "starts_at" TIMESTAMP(3),
    "due_at" TIMESTAMP(3) NOT NULL,
    "late_until" TIMESTAMP(3),
    "late_penalty_pct" DECIMAL(5,2),
    "allow_resubmission" BOOLEAN NOT NULL DEFAULT false,
    "max_attempts" INTEGER NOT NULL DEFAULT 1,
    "is_group" BOOLEAN NOT NULL DEFAULT false,
    "attachments_json" JSONB,
    "rubric_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assignment_submissions" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "assignment_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "attempt_number" INTEGER NOT NULL DEFAULT 1,
    "status" "submission_status" NOT NULL DEFAULT 'NOT_STARTED',
    "submitted_at" TIMESTAMP(3),
    "is_late" BOOLEAN NOT NULL DEFAULT false,
    "content_text" TEXT,
    "attachments_json" JSONB,
    "marks_awarded" DECIMAL(8,2),
    "feedback_text" TEXT,
    "rubric_result_json" JSONB,
    "graded_at" TIMESTAMP(3),
    "graded_by_faculty_id" UUID,
    "similarity_pct" DECIMAL(5,2),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "assignment_submissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quiz_banks" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "subject_id" UUID,
    "course_id" UUID,
    "owner_faculty_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "is_shared" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "quiz_banks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quiz_questions" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "quiz_bank_id" UUID NOT NULL,
    "type" "quiz_question_type" NOT NULL,
    "difficulty" "quiz_difficulty" NOT NULL DEFAULT 'MEDIUM',
    "stem_markdown" TEXT NOT NULL,
    "options_json" JSONB,
    "correct_json" JSONB NOT NULL,
    "explanation" TEXT,
    "marks" DECIMAL(6,2) NOT NULL DEFAULT 1,
    "negative_marks" DECIMAL(6,2) NOT NULL DEFAULT 0,
    "tags" TEXT[],
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "quiz_questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quizzes" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "quiz_bank_id" UUID,
    "course_id" UUID,
    "subject_offering_id" UUID,
    "created_by_faculty_id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "instructions" TEXT,
    "total_marks" DECIMAL(8,2) NOT NULL,
    "duration_min" INTEGER NOT NULL,
    "starts_at" TIMESTAMP(3) NOT NULL,
    "ends_at" TIMESTAMP(3) NOT NULL,
    "max_attempts" INTEGER NOT NULL DEFAULT 1,
    "shuffle_questions" BOOLEAN NOT NULL DEFAULT true,
    "shuffle_options" BOOLEAN NOT NULL DEFAULT true,
    "show_results_immediately" BOOLEAN NOT NULL DEFAULT false,
    "passing_marks" DECIMAL(8,2),
    "is_proctored" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "quizzes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quiz_attempts" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "quiz_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "attempt_number" INTEGER NOT NULL,
    "status" "quiz_attempt_status" NOT NULL DEFAULT 'IN_PROGRESS',
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "submitted_at" TIMESTAMP(3),
    "duration_sec" INTEGER,
    "responses_json" JSONB,
    "ip_address" TEXT,
    "device_info" TEXT,
    "flags_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "quiz_attempts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quiz_results" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "attempt_id" UUID NOT NULL,
    "marks_awarded" DECIMAL(8,2) NOT NULL,
    "total_marks" DECIMAL(8,2) NOT NULL,
    "percentage" DECIMAL(5,2) NOT NULL,
    "passed" BOOLEAN NOT NULL,
    "correct_count" INTEGER NOT NULL,
    "incorrect_count" INTEGER NOT NULL,
    "unanswered_count" INTEGER NOT NULL,
    "per_question_json" JSONB,
    "graded_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "graded_by_user_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "quiz_results_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exams" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "term_id" UUID NOT NULL,
    "program_id" UUID,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "type" "exam_type" NOT NULL,
    "status" "exam_status" NOT NULL DEFAULT 'PLANNED',
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "result_published_at" TIMESTAMP(3),
    "controller_user_id" UUID,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "exams_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exam_schedules" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "exam_id" UUID NOT NULL,
    "subject_offering_id" UUID NOT NULL,
    "section_id" UUID,
    "exam_date" DATE NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL,
    "end_time" TIMESTAMP(3) NOT NULL,
    "duration_min" INTEGER NOT NULL,
    "max_marks" DECIMAL(8,2) NOT NULL,
    "passing_marks" DECIMAL(8,2) NOT NULL,
    "room_id" UUID,
    "status" "exam_schedule_status" NOT NULL DEFAULT 'SCHEDULED',
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "exam_schedules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invigilation_assignments" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "exam_schedule_id" UUID NOT NULL,
    "faculty_id" UUID NOT NULL,
    "room_id" UUID,
    "role" "invigilation_role" NOT NULL DEFAULT 'ASSISTANT',
    "reporting_at" TIMESTAMP(3) NOT NULL,
    "released_at" TIMESTAMP(3),
    "acknowledged" BOOLEAN NOT NULL DEFAULT false,
    "acknowledged_at" TIMESTAMP(3),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "invigilation_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hall_tickets" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "exam_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "ticket_number" TEXT NOT NULL,
    "status" "hall_ticket_status" NOT NULL DEFAULT 'GENERATED',
    "qr_payload" TEXT,
    "issued_at" TIMESTAMP(3),
    "file_object_id" UUID,
    "blocked_reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "hall_tickets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "marks_entries" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "exam_id" UUID NOT NULL,
    "subject_offering_id" UUID NOT NULL,
    "entered_by_faculty_id" UUID NOT NULL,
    "status" "marks_entry_status" NOT NULL DEFAULT 'DRAFT',
    "total_students" INTEGER NOT NULL,
    "entered_count" INTEGER NOT NULL DEFAULT 0,
    "submitted_at" TIMESTAMP(3),
    "approved_at" TIMESTAMP(3),
    "approved_by_user_id" UUID,
    "file_path" TEXT,
    "remarks" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "marks_entries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "moderations" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "marks_entry_id" UUID NOT NULL,
    "moderator_user_id" UUID NOT NULL,
    "scaling_factor" DECIMAL(6,4),
    "grace_marks" DECIMAL(6,2),
    "cutoff_adjustment" DECIMAL(6,2),
    "rationale" TEXT,
    "before_stats_json" JSONB,
    "after_stats_json" JSONB,
    "moderated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "moderations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "results" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "exam_id" UUID NOT NULL,
    "subject_offering_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "marks_obtained" DECIMAL(8,2),
    "max_marks" DECIMAL(8,2) NOT NULL,
    "percentage" DECIMAL(5,2),
    "grade_point" DECIMAL(4,2),
    "grade_letter" TEXT,
    "credits" DECIMAL(4,2),
    "credit_points" DECIMAL(6,2),
    "outcome" "result_grade_outcome" NOT NULL DEFAULT 'PENDING',
    "status" "result_status" NOT NULL DEFAULT 'COMPUTED',
    "published_at" TIMESTAMP(3),
    "revised_at" TIMESTAMP(3),
    "is_makeup" BOOLEAN NOT NULL DEFAULT false,
    "remark" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "results_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transcripts" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "term_id" UUID,
    "is_cumulative" BOOLEAN NOT NULL DEFAULT false,
    "total_credits_earned" DECIMAL(6,2),
    "sgpa" DECIMAL(4,2),
    "cgpa" DECIMAL(4,2),
    "rank" INTEGER,
    "classification" TEXT,
    "issued_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "issued_by_user_id" UUID,
    "file_object_id" UUID,
    "verification_code" TEXT NOT NULL,
    "payload_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "transcripts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "revaluation_requests" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "exam_id" UUID NOT NULL,
    "result_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "reason" TEXT NOT NULL,
    "status" "revaluation_status" NOT NULL DEFAULT 'REQUESTED',
    "fee_amount" DECIMAL(10,2),
    "fee_paid_at" TIMESTAMP(3),
    "invoice_id" UUID,
    "old_marks" DECIMAL(8,2),
    "new_marks" DECIMAL(8,2),
    "decided_at" TIMESTAMP(3),
    "decided_by_user_id" UUID,
    "remarks" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "revaluation_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "registration_cycles" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "term_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "opens_at" TIMESTAMP(3) NOT NULL,
    "closes_at" TIMESTAMP(3) NOT NULL,
    "add_drop_closes_at" TIMESTAMP(3),
    "status" "registration_cycle_status" NOT NULL DEFAULT 'PLANNED',
    "min_credits" DECIMAL(5,2),
    "max_credits" DECIMAL(5,2),
    "rules_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "registration_cycles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "course_registrations" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "cycle_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "term_id" UUID NOT NULL,
    "status" "course_registration_status" NOT NULL DEFAULT 'DRAFT',
    "total_credits" DECIMAL(5,2) NOT NULL DEFAULT 0,
    "submitted_at" TIMESTAMP(3),
    "advisor_approved_at" TIMESTAMP(3),
    "advisor_user_id" UUID,
    "hod_approved_at" TIMESTAMP(3),
    "hod_user_id" UUID,
    "rejected_reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "course_registrations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "registration_subjects" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "registration_id" UUID NOT NULL,
    "subject_offering_id" UUID NOT NULL,
    "status" "registration_subject_status" NOT NULL DEFAULT 'ADDED',
    "is_elective" BOOLEAN NOT NULL DEFAULT false,
    "is_audit" BOOLEAN NOT NULL DEFAULT false,
    "credits" DECIMAL(4,2) NOT NULL,
    "preference_order" INTEGER,
    "added_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "dropped_at" TIMESTAMP(3),
    "reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "registration_subjects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fee_structures" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "program_id" UUID,
    "batch_id" UUID,
    "academic_year_id" UUID NOT NULL,
    "term_id" UUID,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "total_amount" DECIMAL(12,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "components_json" JSONB NOT NULL,
    "due_date" DATE,
    "status" "fee_structure_status" NOT NULL DEFAULT 'DRAFT',
    "effective_from" DATE NOT NULL,
    "effective_to" DATE,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "fee_structures_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoices" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "fee_structure_id" UUID,
    "term_id" UUID,
    "invoice_number" TEXT NOT NULL,
    "status" "invoice_status" NOT NULL DEFAULT 'DRAFT',
    "sub_total" DECIMAL(12,2) NOT NULL,
    "discount_total" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "tax_total" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "grand_total" DECIMAL(12,2) NOT NULL,
    "amount_paid" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "amount_due" DECIMAL(12,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "issued_at" TIMESTAMP(3),
    "due_date" DATE,
    "paid_at" TIMESTAMP(3),
    "cancelled_at" TIMESTAMP(3),
    "line_items_json" JSONB NOT NULL,
    "notes" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "invoices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "invoice_id" UUID,
    "student_id" UUID NOT NULL,
    "payment_number" TEXT NOT NULL,
    "method" "payment_method" NOT NULL,
    "status" "payment_status" NOT NULL DEFAULT 'INITIATED',
    "amount" DECIMAL(12,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "gateway_name" TEXT,
    "gateway_txn_id" TEXT,
    "gateway_response" JSONB,
    "paid_at" TIMESTAMP(3),
    "refunded_at" TIMESTAMP(3),
    "refund_amount" DECIMAL(12,2),
    "receipt_url" TEXT,
    "received_by_user_id" UUID,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "scholarships" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "academic_year_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "sponsor" TEXT,
    "amount" DECIMAL(12,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "status" "scholarship_status" NOT NULL DEFAULT 'APPLIED',
    "applied_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "approved_at" TIMESTAMP(3),
    "approved_by_user_id" UUID,
    "disbursed_at" TIMESTAMP(3),
    "disbursement_method" TEXT,
    "documents_json" JSONB,
    "remarks" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "scholarships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wallets" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "balance" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "hold_amount" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "status" "wallet_status" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "wallets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wallet_transactions" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "wallet_id" UUID NOT NULL,
    "payment_id" UUID,
    "type" "wallet_txn_type" NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "balance_after" DECIMAL(12,2) NOT NULL,
    "reference" TEXT,
    "description" TEXT,
    "metadata" JSONB,
    "created_by_user_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "wallet_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fee_waivers" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "invoice_id" UUID,
    "amount" DECIMAL(12,2) NOT NULL,
    "reason" TEXT NOT NULL,
    "status" "waiver_status" NOT NULL DEFAULT 'REQUESTED',
    "requested_by_user_id" UUID NOT NULL,
    "approved_by_user_id" UUID,
    "approved_at" TIMESTAMP(3),
    "applied_at" TIMESTAMP(3),
    "remarks" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "fee_waivers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "documents" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "owner_user_id" UUID,
    "category" "document_category" NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "file_object_id" UUID NOT NULL,
    "is_public" BOOLEAN NOT NULL DEFAULT false,
    "tags" TEXT[],
    "expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "certificates" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "type" "certificate_type" NOT NULL,
    "status" "certificate_status" NOT NULL DEFAULT 'REQUESTED',
    "certificate_number" TEXT,
    "verification_code" TEXT,
    "purpose" TEXT,
    "requested_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "issued_at" TIMESTAMP(3),
    "issued_by_user_id" UUID,
    "file_object_id" UUID,
    "rejected_reason" TEXT,
    "payload_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "certificates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "help_center_articles" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "category" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "body_markdown" TEXT NOT NULL,
    "tags" TEXT[],
    "is_published" BOOLEAN NOT NULL DEFAULT false,
    "published_at" TIMESTAMP(3),
    "view_count" INTEGER NOT NULL DEFAULT 0,
    "helpful_count" INTEGER NOT NULL DEFAULT 0,
    "author_user_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "help_center_articles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tickets" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "ticket_number" TEXT NOT NULL,
    "raised_by_user_id" UUID NOT NULL,
    "student_id" UUID,
    "category" "ticket_category" NOT NULL,
    "priority" "ticket_priority" NOT NULL DEFAULT 'MEDIUM',
    "status" "ticket_status" NOT NULL DEFAULT 'OPEN',
    "subject" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "assigned_to_user_id" UUID,
    "resolved_at" TIMESTAMP(3),
    "closed_at" TIMESTAMP(3),
    "sla_due_at" TIMESTAMP(3),
    "resolution_text" TEXT,
    "attachments_json" JSONB,
    "thread_json" JSONB,
    "satisfaction_score" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "tickets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "books" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "isbn" TEXT,
    "title" TEXT NOT NULL,
    "subtitle" TEXT,
    "authors" TEXT[],
    "publisher" TEXT,
    "edition" TEXT,
    "publish_year" INTEGER,
    "language" TEXT,
    "category" TEXT,
    "subjects" TEXT[],
    "description" TEXT,
    "cover_url" TEXT,
    "total_copies" INTEGER NOT NULL DEFAULT 0,
    "available_copies" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "books_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "book_copies" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "book_id" UUID NOT NULL,
    "accession_no" TEXT NOT NULL,
    "shelf_location" TEXT,
    "acquired_on" DATE,
    "price" DECIMAL(10,2),
    "status" "book_status" NOT NULL DEFAULT 'AVAILABLE',
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "book_copies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "book_issues" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "book_copy_id" UUID NOT NULL,
    "student_id" UUID,
    "borrower_user_id" UUID NOT NULL,
    "issued_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "due_at" TIMESTAMP(3) NOT NULL,
    "returned_at" TIMESTAMP(3),
    "status" "book_issue_status" NOT NULL DEFAULT 'ISSUED',
    "renewal_count" INTEGER NOT NULL DEFAULT 0,
    "issued_by_user_id" UUID NOT NULL,
    "returned_by_user_id" UUID,
    "fine_amount" DECIMAL(10,2),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "book_issues_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "book_reservations" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "book_id" UUID NOT NULL,
    "student_id" UUID,
    "reserved_by_user_id" UUID NOT NULL,
    "reserved_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "fulfilled_at" TIMESTAMP(3),
    "status" "reservation_status" NOT NULL DEFAULT 'PENDING',
    "queue_position" INTEGER,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "book_reservations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "library_fines" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "book_issue_id" UUID,
    "student_id" UUID,
    "user_id" UUID NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "reason" TEXT NOT NULL,
    "paid" BOOLEAN NOT NULL DEFAULT false,
    "paid_at" TIMESTAMP(3),
    "payment_id" TEXT,
    "waived_at" TIMESTAMP(3),
    "waived_by_user_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "library_fines_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostels" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "campus_id" UUID,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "hostel_type" NOT NULL,
    "total_rooms" INTEGER NOT NULL DEFAULT 0,
    "total_beds" INTEGER NOT NULL DEFAULT 0,
    "warden_user_id" UUID,
    "address" TEXT,
    "amenities_json" JSONB,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "hostels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_rooms" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "hostel_id" UUID NOT NULL,
    "room_number" TEXT NOT NULL,
    "floor" INTEGER,
    "capacity" INTEGER NOT NULL,
    "occupied" INTEGER NOT NULL DEFAULT 0,
    "room_type" TEXT,
    "monthly_rent" DECIMAL(10,2),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "hostel_rooms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_allocations" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "hostel_id" UUID NOT NULL,
    "hostel_room_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "academic_year_id" UUID NOT NULL,
    "bed_number" TEXT,
    "allocated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "checked_in_at" TIMESTAMP(3),
    "checked_out_at" TIMESTAMP(3),
    "vacated_at" TIMESTAMP(3),
    "status" "hostel_allocation_status" NOT NULL DEFAULT 'ALLOCATED',
    "allocated_by_user_id" UUID,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "hostel_allocations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hostel_leave_requests" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "hostel_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "from_date" DATE NOT NULL,
    "to_date" DATE NOT NULL,
    "reason" TEXT NOT NULL,
    "destination" TEXT,
    "emergency_contact" TEXT,
    "status" "leave_request_status" NOT NULL DEFAULT 'REQUESTED',
    "approved_by_user_id" UUID,
    "approved_at" TIMESTAMP(3),
    "rejected_reason" TEXT,
    "actual_return_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "hostel_leave_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transport_routes" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "origin" TEXT NOT NULL,
    "destination" TEXT NOT NULL,
    "distance_km" DECIMAL(6,2),
    "fee_per_term" DECIMAL(10,2),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "transport_routes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transport_vehicles" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "route_id" UUID,
    "registration_no" TEXT NOT NULL,
    "model" TEXT,
    "capacity" INTEGER NOT NULL,
    "driver_name" TEXT,
    "driver_phone" TEXT,
    "driver_license" TEXT,
    "insurance_expires_on" DATE,
    "pollution_expires_on" DATE,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "transport_vehicles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transport_stops" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "route_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "sequence" INTEGER NOT NULL,
    "pickup_time" TEXT,
    "drop_time" TEXT,
    "geo_lat" DECIMAL(10,7),
    "geo_lng" DECIMAL(10,7),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "transport_stops_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transport_passes" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "route_id" UUID NOT NULL,
    "stop_id" UUID,
    "academic_year_id" UUID NOT NULL,
    "pass_number" TEXT NOT NULL,
    "valid_from" DATE NOT NULL,
    "valid_to" DATE NOT NULL,
    "status" "transport_pass_status" NOT NULL DEFAULT 'ACTIVE',
    "fee_paid" BOOLEAN NOT NULL DEFAULT false,
    "invoice_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "transport_passes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "clubs" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "category" TEXT,
    "description" TEXT,
    "faculty_advisor_faculty_id" UUID,
    "president_user_id" UUID,
    "founded_on" DATE,
    "logo_url" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "clubs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "club_memberships" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "club_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'MEMBER',
    "joined_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "left_at" TIMESTAMP(3),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "club_memberships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "events" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "club_id" UUID,
    "organizer_user_id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "category" TEXT,
    "start_at" TIMESTAMP(3) NOT NULL,
    "end_at" TIMESTAMP(3) NOT NULL,
    "venue" TEXT,
    "room_id" TEXT,
    "status" "event_status" NOT NULL DEFAULT 'PLANNED',
    "registration_opens_at" TIMESTAMP(3),
    "registration_closes_at" TIMESTAMP(3),
    "capacity" INTEGER,
    "fee_amount" DECIMAL(10,2),
    "banner_url" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_registrations" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "event_id" UUID NOT NULL,
    "student_id" UUID,
    "user_id" UUID NOT NULL,
    "registered_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "attended" BOOLEAN,
    "checked_in_at" TIMESTAMP(3),
    "fee_paid" BOOLEAN NOT NULL DEFAULT false,
    "cancelled_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "event_registrations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "feedback" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "submitted_by_user_id" UUID NOT NULL,
    "student_id" UUID,
    "target_type" "feedback_target_type" NOT NULL,
    "target_id" TEXT NOT NULL,
    "rating" INTEGER NOT NULL,
    "title" TEXT,
    "comments" TEXT,
    "is_anonymous" BOOLEAN NOT NULL DEFAULT false,
    "responses_json" JSONB,
    "term_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "feedback_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "companies" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "legal_name" TEXT,
    "website" TEXT,
    "industry" TEXT,
    "size" "company_size",
    "hq_location" TEXT,
    "description" TEXT,
    "logo_url" TEXT,
    "status" "company_status" NOT NULL DEFAULT 'ACTIVE',
    "primary_contact_name" TEXT,
    "primary_contact_email" TEXT,
    "primary_contact_phone" TEXT,
    "mou_signed_at" DATE,
    "blacklist_reason" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "companies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "placement_drives" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "company_id" UUID NOT NULL,
    "academic_year_id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "type" "drive_type" NOT NULL,
    "status" "drive_status" NOT NULL DEFAULT 'PLANNED',
    "job_role" TEXT NOT NULL,
    "job_description" TEXT,
    "ctc_min" DECIMAL(12,2),
    "ctc_max" DECIMAL(12,2),
    "stipend" DECIMAL(12,2),
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "locations" TEXT[],
    "bond_years" INTEGER,
    "eligibility_json" JSONB,
    "min_cgpa" DECIMAL(4,2),
    "max_backlogs" INTEGER,
    "eligible_programs_json" JSONB,
    "registration_opens_at" TIMESTAMP(3),
    "registration_closes_at" TIMESTAMP(3),
    "drive_date" DATE,
    "total_seats" INTEGER,
    "coordinator_user_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "placement_drives_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "placement_applications" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "drive_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "applied_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "stage" "application_stage" NOT NULL DEFAULT 'APPLIED',
    "resume_file_object_id" UUID,
    "cover_letter" TEXT,
    "test_scores_json" JSONB,
    "notes" TEXT,
    "rejected_at" TIMESTAMP(3),
    "rejected_reason" TEXT,
    "withdrawn_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "placement_applications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "placement_offers" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "drive_id" UUID NOT NULL,
    "application_id" UUID NOT NULL,
    "company_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "type" "offer_type" NOT NULL,
    "status" "offer_status" NOT NULL DEFAULT 'EXTENDED',
    "job_role" TEXT NOT NULL,
    "ctc" DECIMAL(12,2) NOT NULL,
    "base_salary" DECIMAL(12,2),
    "stipend" DECIMAL(12,2),
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "location" TEXT,
    "joining_date" DATE,
    "offer_letter_file_object_id" UUID,
    "extended_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "response_deadline" TIMESTAMP(3),
    "accepted_at" TIMESTAMP(3),
    "declined_at" TIMESTAMP(3),
    "declined_reason" TEXT,
    "revoked_at" TIMESTAMP(3),
    "is_primary_offer" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "placement_offers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "research_projects" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "department_id" UUID,
    "principal_investigator_faculty_id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "abstract" TEXT,
    "domain" TEXT,
    "keywords" TEXT[],
    "status" "research_project_status" NOT NULL DEFAULT 'PROPOSED',
    "start_date" DATE,
    "end_date" DATE,
    "budget_amount" DECIMAL(14,2),
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "funding_source" TEXT,
    "collaborators_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "research_projects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "publications" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "project_id" UUID,
    "type" "publication_type" NOT NULL,
    "title" TEXT NOT NULL,
    "abstract" TEXT,
    "authors" TEXT[],
    "primary_author_faculty_id" UUID,
    "venue" TEXT,
    "publisher" TEXT,
    "doi" TEXT,
    "isbn" TEXT,
    "issn" TEXT,
    "volume" TEXT,
    "issue" TEXT,
    "page_start" TEXT,
    "page_end" TEXT,
    "published_on" DATE,
    "indexing_json" JSONB,
    "impact_factor" DECIMAL(6,3),
    "citation_count" INTEGER NOT NULL DEFAULT 0,
    "url" TEXT,
    "file_object_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "publications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "grants" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "project_id" UUID,
    "title" TEXT NOT NULL,
    "funding_agency" TEXT NOT NULL,
    "scheme_name" TEXT,
    "amount_sanctioned" DECIMAL(14,2),
    "amount_released" DECIMAL(14,2),
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "status" "grant_status" NOT NULL DEFAULT 'PROPOSED',
    "applied_on" DATE,
    "sanctioned_on" DATE,
    "start_date" DATE,
    "end_date" DATE,
    "pi_faculty_id" UUID NOT NULL,
    "co_pis" TEXT[],
    "reference_number" TEXT,
    "documents_json" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "grants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "patents" (
    "id" UUID NOT NULL,
    "institute_id" UUID NOT NULL,
    "project_id" UUID,
    "title" TEXT NOT NULL,
    "abstract" TEXT,
    "inventors" TEXT[],
    "primary_inventor_faculty_id" UUID,
    "application_number" TEXT,
    "patent_number" TEXT,
    "status" "patent_status" NOT NULL DEFAULT 'IDEA',
    "jurisdiction" TEXT,
    "filed_on" DATE,
    "published_on" DATE,
    "granted_on" DATE,
    "expires_on" DATE,
    "classification" TEXT,
    "url" TEXT,
    "file_object_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "patents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IdempotencyKey" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "instituteId" UUID,
    "userId" UUID NOT NULL,
    "key" TEXT NOT NULL,
    "route" TEXT NOT NULL,
    "requestHash" TEXT NOT NULL,
    "state" "IdempotencyState" NOT NULL DEFAULT 'in_flight',
    "responseCode" INTEGER,
    "responseBody" JSONB,
    "completedAt" TIMESTAMP(3),
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "IdempotencyKey_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FeatureFlag" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "key" TEXT NOT NULL,
    "description" TEXT,
    "rolloutType" "FeatureRolloutType" NOT NULL DEFAULT 'per_institute',
    "defaultOn" BOOLEAN NOT NULL DEFAULT false,
    "payload" JSONB,
    "ownerTeam" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "archivedAt" TIMESTAMP(3),

    CONSTRAINT "FeatureFlag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InstituteFeatureFlag" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "instituteId" UUID NOT NULL,
    "flagId" UUID NOT NULL,
    "isEnabled" BOOLEAN NOT NULL DEFAULT false,
    "variantJson" JSONB,
    "enabledAt" TIMESTAMP(3),
    "disabledAt" TIMESTAMP(3),
    "reason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "InstituteFeatureFlag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ApprovalEscalation" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "instituteId" UUID NOT NULL,
    "instanceId" UUID NOT NULL,
    "level" INTEGER NOT NULL,
    "state" "EscalationState" NOT NULL DEFAULT 'scheduled',
    "fireAt" TIMESTAMP(3) NOT NULL,
    "firedAt" TIMESTAMP(3),
    "resolvedAt" TIMESTAMP(3),
    "resolvedById" UUID,
    "reason" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ApprovalEscalation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MentorAssignment" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "instituteId" UUID NOT NULL,
    "mentorId" UUID NOT NULL,
    "studentId" UUID NOT NULL,
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endedAt" TIMESTAMP(3),
    "reason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MentorAssignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MentorSession" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "assignmentId" UUID NOT NULL,
    "runByMentorId" UUID NOT NULL,
    "scheduledAt" TIMESTAMP(3) NOT NULL,
    "durationMin" INTEGER NOT NULL DEFAULT 30,
    "modality" TEXT NOT NULL,
    "agenda" TEXT,
    "notes" TEXT,
    "actionItems" JSONB,
    "followUpAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MentorSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OnlineExamMedia" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "instituteId" UUID NOT NULL,
    "examId" UUID NOT NULL,
    "studentId" UUID,
    "kind" "OnlineExamMediaKind" NOT NULL,
    "storageKey" TEXT NOT NULL,
    "mimeType" TEXT,
    "bytes" INTEGER,
    "capturedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OnlineExamMedia_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "I18nString" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "namespace" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "locale" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "I18nString_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NotificationProviderConfig" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "instituteId" UUID NOT NULL,
    "channel" "NotificationChannel" NOT NULL,
    "provider" "NotificationProvider" NOT NULL,
    "configJson" JSONB NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "NotificationProviderConfig_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "institutes_code_key" ON "institutes"("code");

-- CreateIndex
CREATE UNIQUE INDEX "institutes_domain_key" ON "institutes"("domain");

-- CreateIndex
CREATE INDEX "institutes_status_idx" ON "institutes"("status");

-- CreateIndex
CREATE INDEX "institutes_deleted_at_idx" ON "institutes"("deleted_at");

-- CreateIndex
CREATE INDEX "campuses_institute_id_status_idx" ON "campuses"("institute_id", "status");

-- CreateIndex
CREATE INDEX "campuses_deleted_at_idx" ON "campuses"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "campuses_institute_id_code_key" ON "campuses"("institute_id", "code");

-- CreateIndex
CREATE INDEX "schools_campus_id_status_idx" ON "schools"("campus_id", "status");

-- CreateIndex
CREATE INDEX "schools_deleted_at_idx" ON "schools"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "schools_institute_id_code_key" ON "schools"("institute_id", "code");

-- CreateIndex
CREATE INDEX "departments_campus_id_status_idx" ON "departments"("campus_id", "status");

-- CreateIndex
CREATE INDEX "departments_school_id_status_idx" ON "departments"("school_id", "status");

-- CreateIndex
CREATE INDEX "departments_deleted_at_idx" ON "departments"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "departments_institute_id_code_key" ON "departments"("institute_id", "code");

-- CreateIndex
CREATE UNIQUE INDEX "departments_school_id_code_key" ON "departments"("school_id", "code");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_key" ON "users"("phone");

-- CreateIndex
CREATE INDEX "users_institute_id_status_idx" ON "users"("institute_id", "status");

-- CreateIndex
CREATE INDEX "users_status_idx" ON "users"("status");

-- CreateIndex
CREATE INDEX "users_deleted_at_idx" ON "users"("deleted_at");

-- CreateIndex
CREATE INDEX "users_last_login_at_idx" ON "users"("last_login_at");

-- CreateIndex
CREATE INDEX "roles_kind_idx" ON "roles"("kind");

-- CreateIndex
CREATE INDEX "roles_deleted_at_idx" ON "roles"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "roles_institute_id_key_key" ON "roles"("institute_id", "key");

-- CreateIndex
CREATE UNIQUE INDEX "permissions_key_key" ON "permissions"("key");

-- CreateIndex
CREATE INDEX "permissions_module_idx" ON "permissions"("module");

-- CreateIndex
CREATE INDEX "permissions_module_action_idx" ON "permissions"("module", "action");

-- CreateIndex
CREATE INDEX "role_permissions_permission_id_idx" ON "role_permissions"("permission_id");

-- CreateIndex
CREATE INDEX "user_roles_user_id_is_primary_idx" ON "user_roles"("user_id", "is_primary");

-- CreateIndex
CREATE INDEX "user_roles_role_id_idx" ON "user_roles"("role_id");

-- CreateIndex
CREATE INDEX "user_roles_institute_id_scope_type_idx" ON "user_roles"("institute_id", "scope_type");

-- CreateIndex
CREATE INDEX "user_roles_scope_type_scope_id_idx" ON "user_roles"("scope_type", "scope_id");

-- CreateIndex
CREATE INDEX "user_roles_deleted_at_idx" ON "user_roles"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "user_roles_user_id_role_id_scope_type_scope_id_key" ON "user_roles"("user_id", "role_id", "scope_type", "scope_id");

-- CreateIndex
CREATE INDEX "user_scopes_institute_id_scope_type_idx" ON "user_scopes"("institute_id", "scope_type");

-- CreateIndex
CREATE INDEX "user_scopes_scope_type_scope_id_idx" ON "user_scopes"("scope_type", "scope_id");

-- CreateIndex
CREATE INDEX "user_scopes_deleted_at_idx" ON "user_scopes"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "user_scopes_user_id_scope_type_scope_id_key" ON "user_scopes"("user_id", "scope_type", "scope_id");

-- CreateIndex
CREATE INDEX "auth_credentials_user_id_is_current_idx" ON "auth_credentials"("user_id", "is_current");

-- CreateIndex
CREATE UNIQUE INDEX "sessions_refresh_token_hash_key" ON "sessions"("refresh_token_hash");

-- CreateIndex
CREATE INDEX "sessions_user_id_status_idx" ON "sessions"("user_id", "status");

-- CreateIndex
CREATE INDEX "sessions_refresh_family_id_idx" ON "sessions"("refresh_family_id");

-- CreateIndex
CREATE INDEX "sessions_expires_at_idx" ON "sessions"("expires_at");

-- CreateIndex
CREATE INDEX "login_attempts_user_id_attempted_at_idx" ON "login_attempts"("user_id", "attempted_at");

-- CreateIndex
CREATE INDEX "login_attempts_email_tried_attempted_at_idx" ON "login_attempts"("email_tried", "attempted_at");

-- CreateIndex
CREATE INDEX "login_attempts_result_attempted_at_idx" ON "login_attempts"("result", "attempted_at");

-- CreateIndex
CREATE INDEX "login_attempts_ip_address_attempted_at_idx" ON "login_attempts"("ip_address", "attempted_at");

-- CreateIndex
CREATE INDEX "mfa_factors_user_id_status_idx" ON "mfa_factors"("user_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "mfa_factors_user_id_type_label_key" ON "mfa_factors"("user_id", "type", "label");

-- CreateIndex
CREATE UNIQUE INDEX "password_reset_tokens_token_hash_key" ON "password_reset_tokens"("token_hash");

-- CreateIndex
CREATE INDEX "password_reset_tokens_user_id_idx" ON "password_reset_tokens"("user_id");

-- CreateIndex
CREATE INDEX "password_reset_tokens_expires_at_idx" ON "password_reset_tokens"("expires_at");

-- CreateIndex
CREATE UNIQUE INDEX "email_verification_tokens_token_hash_key" ON "email_verification_tokens"("token_hash");

-- CreateIndex
CREATE INDEX "email_verification_tokens_user_id_idx" ON "email_verification_tokens"("user_id");

-- CreateIndex
CREATE INDEX "security_events_institute_id_occurred_at_idx" ON "security_events"("institute_id", "occurred_at");

-- CreateIndex
CREATE INDEX "security_events_user_id_occurred_at_idx" ON "security_events"("user_id", "occurred_at");

-- CreateIndex
CREATE INDEX "security_events_event_type_occurred_at_idx" ON "security_events"("event_type", "occurred_at");

-- CreateIndex
CREATE INDEX "security_events_severity_occurred_at_idx" ON "security_events"("severity", "occurred_at");

-- CreateIndex
CREATE INDEX "audit_logs_institute_id_occurred_at_idx" ON "audit_logs"("institute_id", "occurred_at");

-- CreateIndex
CREATE INDEX "audit_logs_actor_user_id_occurred_at_idx" ON "audit_logs"("actor_user_id", "occurred_at");

-- CreateIndex
CREATE INDEX "audit_logs_entity_type_entity_id_idx" ON "audit_logs"("entity_type", "entity_id");

-- CreateIndex
CREATE INDEX "audit_logs_action_occurred_at_idx" ON "audit_logs"("action", "occurred_at");

-- CreateIndex
CREATE INDEX "audit_logs_request_id_idx" ON "audit_logs"("request_id");

-- CreateIndex
CREATE INDEX "workflow_definitions_entity_type_idx" ON "workflow_definitions"("entity_type");

-- CreateIndex
CREATE UNIQUE INDEX "workflow_definitions_institute_id_key_version_key" ON "workflow_definitions"("institute_id", "key", "version");

-- CreateIndex
CREATE UNIQUE INDEX "workflow_steps_workflow_id_sequence_key" ON "workflow_steps"("workflow_id", "sequence");

-- CreateIndex
CREATE INDEX "workflow_instances_institute_id_status_idx" ON "workflow_instances"("institute_id", "status");

-- CreateIndex
CREATE INDEX "workflow_instances_entity_type_entity_id_idx" ON "workflow_instances"("entity_type", "entity_id");

-- CreateIndex
CREATE INDEX "workflow_instances_initiator_user_id_idx" ON "workflow_instances"("initiator_user_id");

-- CreateIndex
CREATE INDEX "workflow_instances_status_due_at_idx" ON "workflow_instances"("status", "due_at");

-- CreateIndex
CREATE INDEX "workflow_instances_deleted_at_idx" ON "workflow_instances"("deleted_at");

-- CreateIndex
CREATE INDEX "workflow_actions_instance_id_performed_at_idx" ON "workflow_actions"("instance_id", "performed_at");

-- CreateIndex
CREATE INDEX "workflow_actions_actor_user_id_performed_at_idx" ON "workflow_actions"("actor_user_id", "performed_at");

-- CreateIndex
CREATE INDEX "workflow_actions_action_type_idx" ON "workflow_actions"("action_type");

-- CreateIndex
CREATE INDEX "notification_templates_key_idx" ON "notification_templates"("key");

-- CreateIndex
CREATE UNIQUE INDEX "notification_templates_institute_id_key_channel_locale_key" ON "notification_templates"("institute_id", "key", "channel", "locale");

-- CreateIndex
CREATE INDEX "notifications_recipient_id_status_created_at_idx" ON "notifications"("recipient_id", "status", "created_at");

-- CreateIndex
CREATE INDEX "notifications_institute_id_event_key_created_at_idx" ON "notifications"("institute_id", "event_key", "created_at");

-- CreateIndex
CREATE INDEX "notifications_status_scheduled_for_idx" ON "notifications"("status", "scheduled_for");

-- CreateIndex
CREATE INDEX "notifications_related_entity_type_related_entity_id_idx" ON "notifications"("related_entity_type", "related_entity_id");

-- CreateIndex
CREATE INDEX "notifications_deleted_at_idx" ON "notifications"("deleted_at");

-- CreateIndex
CREATE INDEX "notification_preferences_user_id_idx" ON "notification_preferences"("user_id");

-- CreateIndex
CREATE INDEX "file_objects_institute_id_created_at_idx" ON "file_objects"("institute_id", "created_at");

-- CreateIndex
CREATE INDEX "file_objects_uploaded_by_id_idx" ON "file_objects"("uploaded_by_id");

-- CreateIndex
CREATE INDEX "file_objects_related_entity_type_related_entity_id_idx" ON "file_objects"("related_entity_type", "related_entity_id");

-- CreateIndex
CREATE INDEX "file_objects_scan_status_idx" ON "file_objects"("scan_status");

-- CreateIndex
CREATE INDEX "file_objects_deleted_at_idx" ON "file_objects"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "file_objects_bucket_storage_key_key" ON "file_objects"("bucket", "storage_key");

-- CreateIndex
CREATE INDEX "file_access_grants_file_id_idx" ON "file_access_grants"("file_id");

-- CreateIndex
CREATE INDEX "file_access_grants_granted_to_id_idx" ON "file_access_grants"("granted_to_id");

-- CreateIndex
CREATE INDEX "file_access_grants_expires_at_idx" ON "file_access_grants"("expires_at");

-- CreateIndex
CREATE INDEX "settings_scope_type_scope_id_idx" ON "settings"("scope_type", "scope_id");

-- CreateIndex
CREATE INDEX "settings_category_key_idx" ON "settings"("category", "key");

-- CreateIndex
CREATE INDEX "settings_deleted_at_idx" ON "settings"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "settings_scope_type_scope_id_category_key_key" ON "settings"("scope_type", "scope_id", "category", "key");

-- CreateIndex
CREATE INDEX "academic_years_institute_id_status_idx" ON "academic_years"("institute_id", "status");

-- CreateIndex
CREATE INDEX "academic_years_institute_id_is_current_idx" ON "academic_years"("institute_id", "is_current");

-- CreateIndex
CREATE INDEX "academic_years_deleted_at_idx" ON "academic_years"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "academic_years_institute_id_code_key" ON "academic_years"("institute_id", "code");

-- CreateIndex
CREATE INDEX "terms_institute_id_status_idx" ON "terms"("institute_id", "status");

-- CreateIndex
CREATE INDEX "terms_institute_id_is_current_idx" ON "terms"("institute_id", "is_current");

-- CreateIndex
CREATE INDEX "terms_academic_year_id_status_idx" ON "terms"("academic_year_id", "status");

-- CreateIndex
CREATE INDEX "terms_deleted_at_idx" ON "terms"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "terms_academic_year_id_code_key" ON "terms"("academic_year_id", "code");

-- CreateIndex
CREATE UNIQUE INDEX "terms_academic_year_id_sequence_key" ON "terms"("academic_year_id", "sequence");

-- CreateIndex
CREATE INDEX "programs_institute_id_status_idx" ON "programs"("institute_id", "status");

-- CreateIndex
CREATE INDEX "programs_school_id_status_idx" ON "programs"("school_id", "status");

-- CreateIndex
CREATE INDEX "programs_department_id_status_idx" ON "programs"("department_id", "status");

-- CreateIndex
CREATE INDEX "programs_campus_id_idx" ON "programs"("campus_id");

-- CreateIndex
CREATE INDEX "programs_deleted_at_idx" ON "programs"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "programs_institute_id_code_key" ON "programs"("institute_id", "code");

-- CreateIndex
CREATE INDEX "batches_institute_id_status_idx" ON "batches"("institute_id", "status");

-- CreateIndex
CREATE INDEX "batches_program_id_status_idx" ON "batches"("program_id", "status");

-- CreateIndex
CREATE INDEX "batches_academic_year_id_idx" ON "batches"("academic_year_id");

-- CreateIndex
CREATE INDEX "batches_intake_year_idx" ON "batches"("intake_year");

-- CreateIndex
CREATE INDEX "batches_deleted_at_idx" ON "batches"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "batches_program_id_code_key" ON "batches"("program_id", "code");

-- CreateIndex
CREATE INDEX "sections_institute_id_status_idx" ON "sections"("institute_id", "status");

-- CreateIndex
CREATE INDEX "sections_term_id_status_idx" ON "sections"("term_id", "status");

-- CreateIndex
CREATE INDEX "sections_batch_id_idx" ON "sections"("batch_id");

-- CreateIndex
CREATE INDEX "sections_deleted_at_idx" ON "sections"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "sections_batch_id_term_id_code_key" ON "sections"("batch_id", "term_id", "code");

-- CreateIndex
CREATE INDEX "subjects_institute_id_is_active_idx" ON "subjects"("institute_id", "is_active");

-- CreateIndex
CREATE INDEX "subjects_department_id_idx" ON "subjects"("department_id");

-- CreateIndex
CREATE INDEX "subjects_program_id_term_sequence_idx" ON "subjects"("program_id", "term_sequence");

-- CreateIndex
CREATE INDEX "subjects_deleted_at_idx" ON "subjects"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "subjects_institute_id_code_key" ON "subjects"("institute_id", "code");

-- CreateIndex
CREATE INDEX "subject_prerequisites_prerequisite_id_idx" ON "subject_prerequisites"("prerequisite_id");

-- CreateIndex
CREATE INDEX "subject_offerings_institute_id_status_idx" ON "subject_offerings"("institute_id", "status");

-- CreateIndex
CREATE INDEX "subject_offerings_term_id_status_idx" ON "subject_offerings"("term_id", "status");

-- CreateIndex
CREATE INDEX "subject_offerings_subject_id_idx" ON "subject_offerings"("subject_id");

-- CreateIndex
CREATE INDEX "subject_offerings_section_id_idx" ON "subject_offerings"("section_id");

-- CreateIndex
CREATE INDEX "subject_offerings_department_id_idx" ON "subject_offerings"("department_id");

-- CreateIndex
CREATE INDEX "subject_offerings_deleted_at_idx" ON "subject_offerings"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "subject_offerings_term_id_offering_code_key" ON "subject_offerings"("term_id", "offering_code");

-- CreateIndex
CREATE UNIQUE INDEX "subject_offerings_subject_id_term_id_section_id_key" ON "subject_offerings"("subject_id", "term_id", "section_id");

-- CreateIndex
CREATE UNIQUE INDEX "faculty_user_id_key" ON "faculty"("user_id");

-- CreateIndex
CREATE INDEX "faculty_institute_id_status_idx" ON "faculty"("institute_id", "status");

-- CreateIndex
CREATE INDEX "faculty_department_id_status_idx" ON "faculty"("department_id", "status");

-- CreateIndex
CREATE INDEX "faculty_school_id_status_idx" ON "faculty"("school_id", "status");

-- CreateIndex
CREATE INDEX "faculty_campus_id_idx" ON "faculty"("campus_id");

-- CreateIndex
CREATE INDEX "faculty_designation_idx" ON "faculty"("designation");

-- CreateIndex
CREATE INDEX "faculty_is_hod_idx" ON "faculty"("is_hod");

-- CreateIndex
CREATE INDEX "faculty_deleted_at_idx" ON "faculty"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "faculty_institute_id_employee_code_key" ON "faculty"("institute_id", "employee_code");

-- CreateIndex
CREATE INDEX "faculty_assignments_institute_id_status_idx" ON "faculty_assignments"("institute_id", "status");

-- CreateIndex
CREATE INDEX "faculty_assignments_faculty_id_status_idx" ON "faculty_assignments"("faculty_id", "status");

-- CreateIndex
CREATE INDEX "faculty_assignments_subject_offering_id_status_idx" ON "faculty_assignments"("subject_offering_id", "status");

-- CreateIndex
CREATE INDEX "faculty_assignments_deleted_at_idx" ON "faculty_assignments"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "faculty_assignments_subject_offering_id_faculty_id_role_key" ON "faculty_assignments"("subject_offering_id", "faculty_id", "role");

-- CreateIndex
CREATE INDEX "mentorships_institute_id_status_idx" ON "mentorships"("institute_id", "status");

-- CreateIndex
CREATE INDEX "mentorships_mentor_faculty_id_status_idx" ON "mentorships"("mentor_faculty_id", "status");

-- CreateIndex
CREATE INDEX "mentorships_student_id_status_idx" ON "mentorships"("student_id", "status");

-- CreateIndex
CREATE INDEX "mentorships_type_idx" ON "mentorships"("type");

-- CreateIndex
CREATE INDEX "mentorships_deleted_at_idx" ON "mentorships"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "mentorships_mentor_faculty_id_student_id_type_academic_year_key" ON "mentorships"("mentor_faculty_id", "student_id", "type", "academic_year_id");

-- CreateIndex
CREATE INDEX "faculty_advisors_institute_id_status_idx" ON "faculty_advisors"("institute_id", "status");

-- CreateIndex
CREATE INDEX "faculty_advisors_scope_type_scope_id_idx" ON "faculty_advisors"("scope_type", "scope_id");

-- CreateIndex
CREATE INDEX "faculty_advisors_faculty_id_status_idx" ON "faculty_advisors"("faculty_id", "status");

-- CreateIndex
CREATE INDEX "faculty_advisors_academic_year_id_idx" ON "faculty_advisors"("academic_year_id");

-- CreateIndex
CREATE INDEX "faculty_advisors_deleted_at_idx" ON "faculty_advisors"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "faculty_advisors_faculty_id_scope_type_scope_id_role_academ_key" ON "faculty_advisors"("faculty_id", "scope_type", "scope_id", "role", "academic_year_id");

-- CreateIndex
CREATE INDEX "advisor_students_institute_id_status_idx" ON "advisor_students"("institute_id", "status");

-- CreateIndex
CREATE INDEX "advisor_students_advisor_faculty_id_status_idx" ON "advisor_students"("advisor_faculty_id", "status");

-- CreateIndex
CREATE INDEX "advisor_students_student_id_status_idx" ON "advisor_students"("student_id", "status");

-- CreateIndex
CREATE INDEX "advisor_students_academic_year_id_idx" ON "advisor_students"("academic_year_id");

-- CreateIndex
CREATE INDEX "advisor_students_deleted_at_idx" ON "advisor_students"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "advisor_students_faculty_advisor_id_student_id_role_academi_key" ON "advisor_students"("faculty_advisor_id", "student_id", "role", "academic_year_id");

-- CreateIndex
CREATE UNIQUE INDEX "students_user_id_key" ON "students"("user_id");

-- CreateIndex
CREATE INDEX "students_institute_id_status_idx" ON "students"("institute_id", "status");

-- CreateIndex
CREATE INDEX "students_program_id_batch_id_section_id_idx" ON "students"("program_id", "batch_id", "section_id");

-- CreateIndex
CREATE INDEX "students_deleted_at_idx" ON "students"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "students_institute_id_enrollment_no_key" ON "students"("institute_id", "enrollment_no");

-- CreateIndex
CREATE INDEX "rooms_institute_id_type_is_active_idx" ON "rooms"("institute_id", "type", "is_active");

-- CreateIndex
CREATE INDEX "rooms_campus_id_idx" ON "rooms"("campus_id");

-- CreateIndex
CREATE INDEX "rooms_deleted_at_idx" ON "rooms"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "rooms_institute_id_code_key" ON "rooms"("institute_id", "code");

-- CreateIndex
CREATE INDEX "labs_institute_id_type_is_active_idx" ON "labs"("institute_id", "type", "is_active");

-- CreateIndex
CREATE INDEX "labs_deleted_at_idx" ON "labs"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "labs_institute_id_code_key" ON "labs"("institute_id", "code");

-- CreateIndex
CREATE INDEX "time_slots_institute_id_is_active_idx" ON "time_slots"("institute_id", "is_active");

-- CreateIndex
CREATE INDEX "time_slots_deleted_at_idx" ON "time_slots"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "time_slots_institute_id_slot_order_key" ON "time_slots"("institute_id", "slot_order");

-- CreateIndex
CREATE UNIQUE INDEX "time_slots_institute_id_start_time_end_time_key" ON "time_slots"("institute_id", "start_time", "end_time");

-- CreateIndex
CREATE INDEX "timetables_institute_id_status_idx" ON "timetables"("institute_id", "status");

-- CreateIndex
CREATE INDEX "timetables_term_id_status_idx" ON "timetables"("term_id", "status");

-- CreateIndex
CREATE INDEX "timetables_section_id_status_idx" ON "timetables"("section_id", "status");

-- CreateIndex
CREATE INDEX "timetables_deleted_at_idx" ON "timetables"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "timetables_section_id_term_id_version_key" ON "timetables"("section_id", "term_id", "version");

-- CreateIndex
CREATE INDEX "timetable_entries_institute_id_day_of_week_idx" ON "timetable_entries"("institute_id", "day_of_week");

-- CreateIndex
CREATE INDEX "timetable_entries_primary_faculty_id_day_of_week_time_slot__idx" ON "timetable_entries"("primary_faculty_id", "day_of_week", "time_slot_id");

-- CreateIndex
CREATE INDEX "timetable_entries_subject_offering_id_idx" ON "timetable_entries"("subject_offering_id");

-- CreateIndex
CREATE INDEX "timetable_entries_room_id_day_of_week_time_slot_id_idx" ON "timetable_entries"("room_id", "day_of_week", "time_slot_id");

-- CreateIndex
CREATE INDEX "timetable_entries_lab_id_day_of_week_time_slot_id_idx" ON "timetable_entries"("lab_id", "day_of_week", "time_slot_id");

-- CreateIndex
CREATE INDEX "timetable_entries_deleted_at_idx" ON "timetable_entries"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "timetable_entries_timetable_id_day_of_week_time_slot_id_wee_key" ON "timetable_entries"("timetable_id", "day_of_week", "time_slot_id", "week_parity");

-- CreateIndex
CREATE UNIQUE INDEX "class_sessions_rescheduled_to_id_key" ON "class_sessions"("rescheduled_to_id");

-- CreateIndex
CREATE INDEX "class_sessions_institute_id_session_date_idx" ON "class_sessions"("institute_id", "session_date");

-- CreateIndex
CREATE INDEX "class_sessions_faculty_id_session_date_idx" ON "class_sessions"("faculty_id", "session_date");

-- CreateIndex
CREATE INDEX "class_sessions_section_id_session_date_idx" ON "class_sessions"("section_id", "session_date");

-- CreateIndex
CREATE INDEX "class_sessions_subject_offering_id_session_date_idx" ON "class_sessions"("subject_offering_id", "session_date");

-- CreateIndex
CREATE INDEX "class_sessions_status_session_date_idx" ON "class_sessions"("status", "session_date");

-- CreateIndex
CREATE INDEX "class_sessions_deleted_at_idx" ON "class_sessions"("deleted_at");

-- CreateIndex
CREATE INDEX "faculty_workloads_institute_id_term_id_idx" ON "faculty_workloads"("institute_id", "term_id");

-- CreateIndex
CREATE INDEX "faculty_workloads_deleted_at_idx" ON "faculty_workloads"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "faculty_workloads_faculty_id_term_id_key" ON "faculty_workloads"("faculty_id", "term_id");

-- CreateIndex
CREATE INDEX "courses_institute_id_status_idx" ON "courses"("institute_id", "status");

-- CreateIndex
CREATE INDEX "courses_owner_faculty_id_idx" ON "courses"("owner_faculty_id");

-- CreateIndex
CREATE INDEX "courses_subject_offering_id_idx" ON "courses"("subject_offering_id");

-- CreateIndex
CREATE INDEX "courses_term_id_idx" ON "courses"("term_id");

-- CreateIndex
CREATE INDEX "courses_deleted_at_idx" ON "courses"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "courses_institute_id_code_key" ON "courses"("institute_id", "code");

-- CreateIndex
CREATE INDEX "course_enrollments_institute_id_status_idx" ON "course_enrollments"("institute_id", "status");

-- CreateIndex
CREATE INDEX "course_enrollments_student_id_status_idx" ON "course_enrollments"("student_id", "status");

-- CreateIndex
CREATE INDEX "course_enrollments_deleted_at_idx" ON "course_enrollments"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "course_enrollments_course_id_student_id_key" ON "course_enrollments"("course_id", "student_id");

-- CreateIndex
CREATE INDEX "course_modules_institute_id_course_id_idx" ON "course_modules"("institute_id", "course_id");

-- CreateIndex
CREATE INDEX "course_modules_deleted_at_idx" ON "course_modules"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "course_modules_course_id_parent_id_order_index_key" ON "course_modules"("course_id", "parent_id", "order_index");

-- CreateIndex
CREATE INDEX "lms_sessions_institute_id_type_idx" ON "lms_sessions"("institute_id", "type");

-- CreateIndex
CREATE INDEX "lms_sessions_deleted_at_idx" ON "lms_sessions"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "lms_sessions_module_id_order_index_key" ON "lms_sessions"("module_id", "order_index");

-- CreateIndex
CREATE INDEX "resources_institute_id_type_idx" ON "resources"("institute_id", "type");

-- CreateIndex
CREATE INDEX "resources_course_id_idx" ON "resources"("course_id");

-- CreateIndex
CREATE INDEX "resources_module_id_idx" ON "resources"("module_id");

-- CreateIndex
CREATE INDEX "resources_session_id_idx" ON "resources"("session_id");

-- CreateIndex
CREATE INDEX "resources_deleted_at_idx" ON "resources"("deleted_at");

-- CreateIndex
CREATE INDEX "discussion_threads_institute_id_status_idx" ON "discussion_threads"("institute_id", "status");

-- CreateIndex
CREATE INDEX "discussion_threads_course_id_last_activity_at_idx" ON "discussion_threads"("course_id", "last_activity_at");

-- CreateIndex
CREATE INDEX "discussion_threads_author_user_id_idx" ON "discussion_threads"("author_user_id");

-- CreateIndex
CREATE INDEX "discussion_threads_deleted_at_idx" ON "discussion_threads"("deleted_at");

-- CreateIndex
CREATE INDEX "discussion_comments_institute_id_thread_id_idx" ON "discussion_comments"("institute_id", "thread_id");

-- CreateIndex
CREATE INDEX "discussion_comments_thread_id_created_at_idx" ON "discussion_comments"("thread_id", "created_at");

-- CreateIndex
CREATE INDEX "discussion_comments_author_user_id_idx" ON "discussion_comments"("author_user_id");

-- CreateIndex
CREATE INDEX "discussion_comments_deleted_at_idx" ON "discussion_comments"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "attendance_sessions_class_session_id_key" ON "attendance_sessions"("class_session_id");

-- CreateIndex
CREATE UNIQUE INDEX "attendance_sessions_qr_token_key" ON "attendance_sessions"("qr_token");

-- CreateIndex
CREATE INDEX "attendance_sessions_institute_id_session_date_idx" ON "attendance_sessions"("institute_id", "session_date");

-- CreateIndex
CREATE INDEX "attendance_sessions_section_id_session_date_idx" ON "attendance_sessions"("section_id", "session_date");

-- CreateIndex
CREATE INDEX "attendance_sessions_faculty_id_session_date_idx" ON "attendance_sessions"("faculty_id", "session_date");

-- CreateIndex
CREATE INDEX "attendance_sessions_status_idx" ON "attendance_sessions"("status");

-- CreateIndex
CREATE INDEX "attendance_sessions_deleted_at_idx" ON "attendance_sessions"("deleted_at");

-- CreateIndex
CREATE INDEX "attendance_records_institute_id_status_idx" ON "attendance_records"("institute_id", "status");

-- CreateIndex
CREATE INDEX "attendance_records_student_id_status_idx" ON "attendance_records"("student_id", "status");

-- CreateIndex
CREATE INDEX "attendance_records_deleted_at_idx" ON "attendance_records"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "attendance_records_attendance_session_id_student_id_key" ON "attendance_records"("attendance_session_id", "student_id");

-- CreateIndex
CREATE INDEX "assignment_categories_institute_id_idx" ON "assignment_categories"("institute_id");

-- CreateIndex
CREATE INDEX "assignment_categories_deleted_at_idx" ON "assignment_categories"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "assignment_categories_subject_offering_id_name_key" ON "assignment_categories"("subject_offering_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "assignment_categories_course_id_name_key" ON "assignment_categories"("course_id", "name");

-- CreateIndex
CREATE INDEX "assignments_institute_id_status_idx" ON "assignments"("institute_id", "status");

-- CreateIndex
CREATE INDEX "assignments_course_id_due_at_idx" ON "assignments"("course_id", "due_at");

-- CreateIndex
CREATE INDEX "assignments_subject_offering_id_due_at_idx" ON "assignments"("subject_offering_id", "due_at");

-- CreateIndex
CREATE INDEX "assignments_created_by_faculty_id_idx" ON "assignments"("created_by_faculty_id");

-- CreateIndex
CREATE INDEX "assignments_deleted_at_idx" ON "assignments"("deleted_at");

-- CreateIndex
CREATE INDEX "assignment_submissions_institute_id_status_idx" ON "assignment_submissions"("institute_id", "status");

-- CreateIndex
CREATE INDEX "assignment_submissions_student_id_status_idx" ON "assignment_submissions"("student_id", "status");

-- CreateIndex
CREATE INDEX "assignment_submissions_graded_by_faculty_id_idx" ON "assignment_submissions"("graded_by_faculty_id");

-- CreateIndex
CREATE INDEX "assignment_submissions_deleted_at_idx" ON "assignment_submissions"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "assignment_submissions_assignment_id_student_id_attempt_num_key" ON "assignment_submissions"("assignment_id", "student_id", "attempt_number");

-- CreateIndex
CREATE INDEX "quiz_banks_institute_id_idx" ON "quiz_banks"("institute_id");

-- CreateIndex
CREATE INDEX "quiz_banks_owner_faculty_id_idx" ON "quiz_banks"("owner_faculty_id");

-- CreateIndex
CREATE INDEX "quiz_banks_deleted_at_idx" ON "quiz_banks"("deleted_at");

-- CreateIndex
CREATE INDEX "quiz_questions_institute_id_type_difficulty_idx" ON "quiz_questions"("institute_id", "type", "difficulty");

-- CreateIndex
CREATE INDEX "quiz_questions_quiz_bank_id_idx" ON "quiz_questions"("quiz_bank_id");

-- CreateIndex
CREATE INDEX "quiz_questions_deleted_at_idx" ON "quiz_questions"("deleted_at");

-- CreateIndex
CREATE INDEX "quizzes_institute_id_starts_at_idx" ON "quizzes"("institute_id", "starts_at");

-- CreateIndex
CREATE INDEX "quizzes_course_id_idx" ON "quizzes"("course_id");

-- CreateIndex
CREATE INDEX "quizzes_subject_offering_id_idx" ON "quizzes"("subject_offering_id");

-- CreateIndex
CREATE INDEX "quizzes_deleted_at_idx" ON "quizzes"("deleted_at");

-- CreateIndex
CREATE INDEX "quiz_attempts_institute_id_status_idx" ON "quiz_attempts"("institute_id", "status");

-- CreateIndex
CREATE INDEX "quiz_attempts_student_id_idx" ON "quiz_attempts"("student_id");

-- CreateIndex
CREATE INDEX "quiz_attempts_deleted_at_idx" ON "quiz_attempts"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "quiz_attempts_quiz_id_student_id_attempt_number_key" ON "quiz_attempts"("quiz_id", "student_id", "attempt_number");

-- CreateIndex
CREATE UNIQUE INDEX "quiz_results_attempt_id_key" ON "quiz_results"("attempt_id");

-- CreateIndex
CREATE INDEX "quiz_results_institute_id_idx" ON "quiz_results"("institute_id");

-- CreateIndex
CREATE INDEX "quiz_results_passed_idx" ON "quiz_results"("passed");

-- CreateIndex
CREATE INDEX "quiz_results_deleted_at_idx" ON "quiz_results"("deleted_at");

-- CreateIndex
CREATE INDEX "exams_institute_id_status_idx" ON "exams"("institute_id", "status");

-- CreateIndex
CREATE INDEX "exams_term_id_idx" ON "exams"("term_id");

-- CreateIndex
CREATE INDEX "exams_deleted_at_idx" ON "exams"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "exams_institute_id_code_term_id_key" ON "exams"("institute_id", "code", "term_id");

-- CreateIndex
CREATE INDEX "exam_schedules_institute_id_exam_date_idx" ON "exam_schedules"("institute_id", "exam_date");

-- CreateIndex
CREATE INDEX "exam_schedules_exam_id_idx" ON "exam_schedules"("exam_id");

-- CreateIndex
CREATE INDEX "exam_schedules_subject_offering_id_idx" ON "exam_schedules"("subject_offering_id");

-- CreateIndex
CREATE INDEX "exam_schedules_status_idx" ON "exam_schedules"("status");

-- CreateIndex
CREATE INDEX "exam_schedules_deleted_at_idx" ON "exam_schedules"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "exam_schedules_exam_id_subject_offering_id_section_id_key" ON "exam_schedules"("exam_id", "subject_offering_id", "section_id");

-- CreateIndex
CREATE INDEX "invigilation_assignments_institute_id_faculty_id_idx" ON "invigilation_assignments"("institute_id", "faculty_id");

-- CreateIndex
CREATE INDEX "invigilation_assignments_faculty_id_idx" ON "invigilation_assignments"("faculty_id");

-- CreateIndex
CREATE INDEX "invigilation_assignments_deleted_at_idx" ON "invigilation_assignments"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "invigilation_assignments_exam_schedule_id_faculty_id_key" ON "invigilation_assignments"("exam_schedule_id", "faculty_id");

-- CreateIndex
CREATE INDEX "hall_tickets_student_id_idx" ON "hall_tickets"("student_id");

-- CreateIndex
CREATE INDEX "hall_tickets_status_idx" ON "hall_tickets"("status");

-- CreateIndex
CREATE INDEX "hall_tickets_deleted_at_idx" ON "hall_tickets"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "hall_tickets_exam_id_student_id_key" ON "hall_tickets"("exam_id", "student_id");

-- CreateIndex
CREATE UNIQUE INDEX "hall_tickets_institute_id_ticket_number_key" ON "hall_tickets"("institute_id", "ticket_number");

-- CreateIndex
CREATE INDEX "marks_entries_institute_id_status_idx" ON "marks_entries"("institute_id", "status");

-- CreateIndex
CREATE INDEX "marks_entries_entered_by_faculty_id_idx" ON "marks_entries"("entered_by_faculty_id");

-- CreateIndex
CREATE INDEX "marks_entries_deleted_at_idx" ON "marks_entries"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "marks_entries_exam_id_subject_offering_id_key" ON "marks_entries"("exam_id", "subject_offering_id");

-- CreateIndex
CREATE UNIQUE INDEX "moderations_marks_entry_id_key" ON "moderations"("marks_entry_id");

-- CreateIndex
CREATE INDEX "moderations_institute_id_idx" ON "moderations"("institute_id");

-- CreateIndex
CREATE INDEX "moderations_deleted_at_idx" ON "moderations"("deleted_at");

-- CreateIndex
CREATE INDEX "results_institute_id_status_idx" ON "results"("institute_id", "status");

-- CreateIndex
CREATE INDEX "results_student_id_status_idx" ON "results"("student_id", "status");

-- CreateIndex
CREATE INDEX "results_exam_id_idx" ON "results"("exam_id");

-- CreateIndex
CREATE INDEX "results_outcome_idx" ON "results"("outcome");

-- CreateIndex
CREATE INDEX "results_deleted_at_idx" ON "results"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "results_exam_id_subject_offering_id_student_id_key" ON "results"("exam_id", "subject_offering_id", "student_id");

-- CreateIndex
CREATE UNIQUE INDEX "transcripts_verification_code_key" ON "transcripts"("verification_code");

-- CreateIndex
CREATE INDEX "transcripts_institute_id_idx" ON "transcripts"("institute_id");

-- CreateIndex
CREATE INDEX "transcripts_student_id_idx" ON "transcripts"("student_id");

-- CreateIndex
CREATE INDEX "transcripts_deleted_at_idx" ON "transcripts"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "transcripts_student_id_term_id_is_cumulative_key" ON "transcripts"("student_id", "term_id", "is_cumulative");

-- CreateIndex
CREATE INDEX "revaluation_requests_institute_id_status_idx" ON "revaluation_requests"("institute_id", "status");

-- CreateIndex
CREATE INDEX "revaluation_requests_student_id_idx" ON "revaluation_requests"("student_id");

-- CreateIndex
CREATE INDEX "revaluation_requests_exam_id_idx" ON "revaluation_requests"("exam_id");

-- CreateIndex
CREATE INDEX "revaluation_requests_deleted_at_idx" ON "revaluation_requests"("deleted_at");

-- CreateIndex
CREATE INDEX "registration_cycles_institute_id_status_idx" ON "registration_cycles"("institute_id", "status");

-- CreateIndex
CREATE INDEX "registration_cycles_deleted_at_idx" ON "registration_cycles"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "registration_cycles_term_id_name_key" ON "registration_cycles"("term_id", "name");

-- CreateIndex
CREATE INDEX "course_registrations_institute_id_status_idx" ON "course_registrations"("institute_id", "status");

-- CreateIndex
CREATE INDEX "course_registrations_student_id_term_id_idx" ON "course_registrations"("student_id", "term_id");

-- CreateIndex
CREATE INDEX "course_registrations_deleted_at_idx" ON "course_registrations"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "course_registrations_cycle_id_student_id_key" ON "course_registrations"("cycle_id", "student_id");

-- CreateIndex
CREATE INDEX "registration_subjects_institute_id_status_idx" ON "registration_subjects"("institute_id", "status");

-- CreateIndex
CREATE INDEX "registration_subjects_subject_offering_id_status_idx" ON "registration_subjects"("subject_offering_id", "status");

-- CreateIndex
CREATE INDEX "registration_subjects_deleted_at_idx" ON "registration_subjects"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "registration_subjects_registration_id_subject_offering_id_key" ON "registration_subjects"("registration_id", "subject_offering_id");

-- CreateIndex
CREATE INDEX "fee_structures_institute_id_status_idx" ON "fee_structures"("institute_id", "status");

-- CreateIndex
CREATE INDEX "fee_structures_program_id_batch_id_academic_year_id_idx" ON "fee_structures"("program_id", "batch_id", "academic_year_id");

-- CreateIndex
CREATE INDEX "fee_structures_deleted_at_idx" ON "fee_structures"("deleted_at");

-- CreateIndex
CREATE INDEX "invoices_institute_id_status_idx" ON "invoices"("institute_id", "status");

-- CreateIndex
CREATE INDEX "invoices_student_id_status_idx" ON "invoices"("student_id", "status");

-- CreateIndex
CREATE INDEX "invoices_due_date_idx" ON "invoices"("due_date");

-- CreateIndex
CREATE INDEX "invoices_deleted_at_idx" ON "invoices"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "invoices_institute_id_invoice_number_key" ON "invoices"("institute_id", "invoice_number");

-- CreateIndex
CREATE UNIQUE INDEX "payments_gateway_txn_id_key" ON "payments"("gateway_txn_id");

-- CreateIndex
CREATE INDEX "payments_institute_id_status_idx" ON "payments"("institute_id", "status");

-- CreateIndex
CREATE INDEX "payments_student_id_status_idx" ON "payments"("student_id", "status");

-- CreateIndex
CREATE INDEX "payments_invoice_id_idx" ON "payments"("invoice_id");

-- CreateIndex
CREATE INDEX "payments_deleted_at_idx" ON "payments"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "payments_institute_id_payment_number_key" ON "payments"("institute_id", "payment_number");

-- CreateIndex
CREATE INDEX "scholarships_institute_id_status_idx" ON "scholarships"("institute_id", "status");

-- CreateIndex
CREATE INDEX "scholarships_student_id_idx" ON "scholarships"("student_id");

-- CreateIndex
CREATE INDEX "scholarships_deleted_at_idx" ON "scholarships"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "wallets_student_id_key" ON "wallets"("student_id");

-- CreateIndex
CREATE INDEX "wallets_institute_id_status_idx" ON "wallets"("institute_id", "status");

-- CreateIndex
CREATE INDEX "wallets_deleted_at_idx" ON "wallets"("deleted_at");

-- CreateIndex
CREATE INDEX "wallet_transactions_institute_id_wallet_id_idx" ON "wallet_transactions"("institute_id", "wallet_id");

-- CreateIndex
CREATE INDEX "wallet_transactions_wallet_id_created_at_idx" ON "wallet_transactions"("wallet_id", "created_at");

-- CreateIndex
CREATE INDEX "wallet_transactions_type_idx" ON "wallet_transactions"("type");

-- CreateIndex
CREATE INDEX "wallet_transactions_deleted_at_idx" ON "wallet_transactions"("deleted_at");

-- CreateIndex
CREATE INDEX "fee_waivers_institute_id_status_idx" ON "fee_waivers"("institute_id", "status");

-- CreateIndex
CREATE INDEX "fee_waivers_student_id_idx" ON "fee_waivers"("student_id");

-- CreateIndex
CREATE INDEX "fee_waivers_deleted_at_idx" ON "fee_waivers"("deleted_at");

-- CreateIndex
CREATE INDEX "documents_institute_id_category_idx" ON "documents"("institute_id", "category");

-- CreateIndex
CREATE INDEX "documents_owner_user_id_idx" ON "documents"("owner_user_id");

-- CreateIndex
CREATE INDEX "documents_deleted_at_idx" ON "documents"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "certificates_certificate_number_key" ON "certificates"("certificate_number");

-- CreateIndex
CREATE UNIQUE INDEX "certificates_verification_code_key" ON "certificates"("verification_code");

-- CreateIndex
CREATE INDEX "certificates_institute_id_status_idx" ON "certificates"("institute_id", "status");

-- CreateIndex
CREATE INDEX "certificates_student_id_type_idx" ON "certificates"("student_id", "type");

-- CreateIndex
CREATE INDEX "certificates_deleted_at_idx" ON "certificates"("deleted_at");

-- CreateIndex
CREATE INDEX "help_center_articles_institute_id_category_is_published_idx" ON "help_center_articles"("institute_id", "category", "is_published");

-- CreateIndex
CREATE INDEX "help_center_articles_deleted_at_idx" ON "help_center_articles"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "help_center_articles_institute_id_slug_key" ON "help_center_articles"("institute_id", "slug");

-- CreateIndex
CREATE INDEX "tickets_institute_id_status_priority_idx" ON "tickets"("institute_id", "status", "priority");

-- CreateIndex
CREATE INDEX "tickets_assigned_to_user_id_status_idx" ON "tickets"("assigned_to_user_id", "status");

-- CreateIndex
CREATE INDEX "tickets_raised_by_user_id_idx" ON "tickets"("raised_by_user_id");

-- CreateIndex
CREATE INDEX "tickets_deleted_at_idx" ON "tickets"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "tickets_institute_id_ticket_number_key" ON "tickets"("institute_id", "ticket_number");

-- CreateIndex
CREATE INDEX "books_institute_id_category_idx" ON "books"("institute_id", "category");

-- CreateIndex
CREATE INDEX "books_deleted_at_idx" ON "books"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "books_institute_id_isbn_key" ON "books"("institute_id", "isbn");

-- CreateIndex
CREATE INDEX "book_copies_institute_id_status_idx" ON "book_copies"("institute_id", "status");

-- CreateIndex
CREATE INDEX "book_copies_book_id_status_idx" ON "book_copies"("book_id", "status");

-- CreateIndex
CREATE INDEX "book_copies_deleted_at_idx" ON "book_copies"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "book_copies_institute_id_accession_no_key" ON "book_copies"("institute_id", "accession_no");

-- CreateIndex
CREATE INDEX "book_issues_institute_id_status_idx" ON "book_issues"("institute_id", "status");

-- CreateIndex
CREATE INDEX "book_issues_borrower_user_id_status_idx" ON "book_issues"("borrower_user_id", "status");

-- CreateIndex
CREATE INDEX "book_issues_student_id_status_idx" ON "book_issues"("student_id", "status");

-- CreateIndex
CREATE INDEX "book_issues_due_at_idx" ON "book_issues"("due_at");

-- CreateIndex
CREATE INDEX "book_issues_deleted_at_idx" ON "book_issues"("deleted_at");

-- CreateIndex
CREATE INDEX "book_reservations_institute_id_status_idx" ON "book_reservations"("institute_id", "status");

-- CreateIndex
CREATE INDEX "book_reservations_book_id_status_queue_position_idx" ON "book_reservations"("book_id", "status", "queue_position");

-- CreateIndex
CREATE INDEX "book_reservations_reserved_by_user_id_idx" ON "book_reservations"("reserved_by_user_id");

-- CreateIndex
CREATE INDEX "book_reservations_deleted_at_idx" ON "book_reservations"("deleted_at");

-- CreateIndex
CREATE INDEX "library_fines_institute_id_paid_idx" ON "library_fines"("institute_id", "paid");

-- CreateIndex
CREATE INDEX "library_fines_user_id_paid_idx" ON "library_fines"("user_id", "paid");

-- CreateIndex
CREATE INDEX "library_fines_deleted_at_idx" ON "library_fines"("deleted_at");

-- CreateIndex
CREATE INDEX "hostels_institute_id_type_is_active_idx" ON "hostels"("institute_id", "type", "is_active");

-- CreateIndex
CREATE INDEX "hostels_deleted_at_idx" ON "hostels"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "hostels_institute_id_code_key" ON "hostels"("institute_id", "code");

-- CreateIndex
CREATE INDEX "hostel_rooms_institute_id_hostel_id_is_active_idx" ON "hostel_rooms"("institute_id", "hostel_id", "is_active");

-- CreateIndex
CREATE INDEX "hostel_rooms_deleted_at_idx" ON "hostel_rooms"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "hostel_rooms_hostel_id_room_number_key" ON "hostel_rooms"("hostel_id", "room_number");

-- CreateIndex
CREATE INDEX "hostel_allocations_institute_id_status_idx" ON "hostel_allocations"("institute_id", "status");

-- CreateIndex
CREATE INDEX "hostel_allocations_hostel_id_status_idx" ON "hostel_allocations"("hostel_id", "status");

-- CreateIndex
CREATE INDEX "hostel_allocations_hostel_room_id_status_idx" ON "hostel_allocations"("hostel_room_id", "status");

-- CreateIndex
CREATE INDEX "hostel_allocations_deleted_at_idx" ON "hostel_allocations"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "hostel_allocations_student_id_academic_year_id_status_key" ON "hostel_allocations"("student_id", "academic_year_id", "status");

-- CreateIndex
CREATE INDEX "hostel_leave_requests_institute_id_status_idx" ON "hostel_leave_requests"("institute_id", "status");

-- CreateIndex
CREATE INDEX "hostel_leave_requests_student_id_status_idx" ON "hostel_leave_requests"("student_id", "status");

-- CreateIndex
CREATE INDEX "hostel_leave_requests_from_date_to_date_idx" ON "hostel_leave_requests"("from_date", "to_date");

-- CreateIndex
CREATE INDEX "hostel_leave_requests_deleted_at_idx" ON "hostel_leave_requests"("deleted_at");

-- CreateIndex
CREATE INDEX "transport_routes_institute_id_is_active_idx" ON "transport_routes"("institute_id", "is_active");

-- CreateIndex
CREATE INDEX "transport_routes_deleted_at_idx" ON "transport_routes"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "transport_routes_institute_id_code_key" ON "transport_routes"("institute_id", "code");

-- CreateIndex
CREATE INDEX "transport_vehicles_institute_id_is_active_idx" ON "transport_vehicles"("institute_id", "is_active");

-- CreateIndex
CREATE INDEX "transport_vehicles_route_id_idx" ON "transport_vehicles"("route_id");

-- CreateIndex
CREATE INDEX "transport_vehicles_deleted_at_idx" ON "transport_vehicles"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "transport_vehicles_institute_id_registration_no_key" ON "transport_vehicles"("institute_id", "registration_no");

-- CreateIndex
CREATE INDEX "transport_stops_institute_id_route_id_idx" ON "transport_stops"("institute_id", "route_id");

-- CreateIndex
CREATE INDEX "transport_stops_deleted_at_idx" ON "transport_stops"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "transport_stops_route_id_sequence_key" ON "transport_stops"("route_id", "sequence");

-- CreateIndex
CREATE INDEX "transport_passes_institute_id_status_idx" ON "transport_passes"("institute_id", "status");

-- CreateIndex
CREATE INDEX "transport_passes_route_id_idx" ON "transport_passes"("route_id");

-- CreateIndex
CREATE INDEX "transport_passes_deleted_at_idx" ON "transport_passes"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "transport_passes_institute_id_pass_number_key" ON "transport_passes"("institute_id", "pass_number");

-- CreateIndex
CREATE UNIQUE INDEX "transport_passes_student_id_academic_year_id_status_key" ON "transport_passes"("student_id", "academic_year_id", "status");

-- CreateIndex
CREATE INDEX "clubs_institute_id_is_active_idx" ON "clubs"("institute_id", "is_active");

-- CreateIndex
CREATE INDEX "clubs_deleted_at_idx" ON "clubs"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "clubs_institute_id_code_key" ON "clubs"("institute_id", "code");

-- CreateIndex
CREATE INDEX "club_memberships_institute_id_is_active_idx" ON "club_memberships"("institute_id", "is_active");

-- CreateIndex
CREATE INDEX "club_memberships_student_id_is_active_idx" ON "club_memberships"("student_id", "is_active");

-- CreateIndex
CREATE INDEX "club_memberships_deleted_at_idx" ON "club_memberships"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "club_memberships_club_id_student_id_key" ON "club_memberships"("club_id", "student_id");

-- CreateIndex
CREATE INDEX "events_institute_id_status_idx" ON "events"("institute_id", "status");

-- CreateIndex
CREATE INDEX "events_start_at_idx" ON "events"("start_at");

-- CreateIndex
CREATE INDEX "events_club_id_idx" ON "events"("club_id");

-- CreateIndex
CREATE INDEX "events_deleted_at_idx" ON "events"("deleted_at");

-- CreateIndex
CREATE INDEX "event_registrations_institute_id_event_id_idx" ON "event_registrations"("institute_id", "event_id");

-- CreateIndex
CREATE INDEX "event_registrations_user_id_idx" ON "event_registrations"("user_id");

-- CreateIndex
CREATE INDEX "event_registrations_deleted_at_idx" ON "event_registrations"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "event_registrations_event_id_user_id_key" ON "event_registrations"("event_id", "user_id");

-- CreateIndex
CREATE INDEX "feedback_institute_id_target_type_target_id_idx" ON "feedback"("institute_id", "target_type", "target_id");

-- CreateIndex
CREATE INDEX "feedback_rating_idx" ON "feedback"("rating");

-- CreateIndex
CREATE INDEX "feedback_deleted_at_idx" ON "feedback"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "feedback_submitted_by_user_id_target_type_target_id_term_id_key" ON "feedback"("submitted_by_user_id", "target_type", "target_id", "term_id");

-- CreateIndex
CREATE INDEX "companies_institute_id_status_idx" ON "companies"("institute_id", "status");

-- CreateIndex
CREATE INDEX "companies_deleted_at_idx" ON "companies"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "companies_institute_id_name_key" ON "companies"("institute_id", "name");

-- CreateIndex
CREATE INDEX "placement_drives_institute_id_status_idx" ON "placement_drives"("institute_id", "status");

-- CreateIndex
CREATE INDEX "placement_drives_company_id_idx" ON "placement_drives"("company_id");

-- CreateIndex
CREATE INDEX "placement_drives_academic_year_id_status_idx" ON "placement_drives"("academic_year_id", "status");

-- CreateIndex
CREATE INDEX "placement_drives_deleted_at_idx" ON "placement_drives"("deleted_at");

-- CreateIndex
CREATE INDEX "placement_applications_institute_id_stage_idx" ON "placement_applications"("institute_id", "stage");

-- CreateIndex
CREATE INDEX "placement_applications_student_id_stage_idx" ON "placement_applications"("student_id", "stage");

-- CreateIndex
CREATE INDEX "placement_applications_deleted_at_idx" ON "placement_applications"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "placement_applications_drive_id_student_id_key" ON "placement_applications"("drive_id", "student_id");

-- CreateIndex
CREATE INDEX "placement_offers_institute_id_status_idx" ON "placement_offers"("institute_id", "status");

-- CreateIndex
CREATE INDEX "placement_offers_student_id_status_idx" ON "placement_offers"("student_id", "status");

-- CreateIndex
CREATE INDEX "placement_offers_drive_id_idx" ON "placement_offers"("drive_id");

-- CreateIndex
CREATE INDEX "placement_offers_company_id_idx" ON "placement_offers"("company_id");

-- CreateIndex
CREATE INDEX "placement_offers_deleted_at_idx" ON "placement_offers"("deleted_at");

-- CreateIndex
CREATE INDEX "research_projects_institute_id_status_idx" ON "research_projects"("institute_id", "status");

-- CreateIndex
CREATE INDEX "research_projects_principal_investigator_faculty_id_idx" ON "research_projects"("principal_investigator_faculty_id");

-- CreateIndex
CREATE INDEX "research_projects_department_id_idx" ON "research_projects"("department_id");

-- CreateIndex
CREATE INDEX "research_projects_deleted_at_idx" ON "research_projects"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "publications_doi_key" ON "publications"("doi");

-- CreateIndex
CREATE INDEX "publications_institute_id_type_idx" ON "publications"("institute_id", "type");

-- CreateIndex
CREATE INDEX "publications_primary_author_faculty_id_idx" ON "publications"("primary_author_faculty_id");

-- CreateIndex
CREATE INDEX "publications_project_id_idx" ON "publications"("project_id");

-- CreateIndex
CREATE INDEX "publications_published_on_idx" ON "publications"("published_on");

-- CreateIndex
CREATE INDEX "publications_deleted_at_idx" ON "publications"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "grants_reference_number_key" ON "grants"("reference_number");

-- CreateIndex
CREATE INDEX "grants_institute_id_status_idx" ON "grants"("institute_id", "status");

-- CreateIndex
CREATE INDEX "grants_project_id_idx" ON "grants"("project_id");

-- CreateIndex
CREATE INDEX "grants_pi_faculty_id_idx" ON "grants"("pi_faculty_id");

-- CreateIndex
CREATE INDEX "grants_deleted_at_idx" ON "grants"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "patents_application_number_key" ON "patents"("application_number");

-- CreateIndex
CREATE UNIQUE INDEX "patents_patent_number_key" ON "patents"("patent_number");

-- CreateIndex
CREATE INDEX "patents_institute_id_status_idx" ON "patents"("institute_id", "status");

-- CreateIndex
CREATE INDEX "patents_primary_inventor_faculty_id_idx" ON "patents"("primary_inventor_faculty_id");

-- CreateIndex
CREATE INDEX "patents_project_id_idx" ON "patents"("project_id");

-- CreateIndex
CREATE INDEX "patents_deleted_at_idx" ON "patents"("deleted_at");

-- CreateIndex
CREATE INDEX "IdempotencyKey_expiresAt_idx" ON "IdempotencyKey"("expiresAt");

-- CreateIndex
CREATE INDEX "IdempotencyKey_state_idx" ON "IdempotencyKey"("state");

-- CreateIndex
CREATE UNIQUE INDEX "IdempotencyKey_userId_route_key_key" ON "IdempotencyKey"("userId", "route", "key");

-- CreateIndex
CREATE UNIQUE INDEX "FeatureFlag_key_key" ON "FeatureFlag"("key");

-- CreateIndex
CREATE INDEX "FeatureFlag_rolloutType_idx" ON "FeatureFlag"("rolloutType");

-- CreateIndex
CREATE INDEX "InstituteFeatureFlag_flagId_isEnabled_idx" ON "InstituteFeatureFlag"("flagId", "isEnabled");

-- CreateIndex
CREATE UNIQUE INDEX "InstituteFeatureFlag_instituteId_flagId_key" ON "InstituteFeatureFlag"("instituteId", "flagId");

-- CreateIndex
CREATE INDEX "ApprovalEscalation_state_fireAt_idx" ON "ApprovalEscalation"("state", "fireAt");

-- CreateIndex
CREATE UNIQUE INDEX "ApprovalEscalation_instanceId_level_key" ON "ApprovalEscalation"("instanceId", "level");

-- CreateIndex
CREATE INDEX "MentorAssignment_instituteId_mentorId_idx" ON "MentorAssignment"("instituteId", "mentorId");

-- CreateIndex
CREATE INDEX "MentorAssignment_studentId_idx" ON "MentorAssignment"("studentId");

-- CreateIndex
CREATE INDEX "MentorSession_assignmentId_scheduledAt_idx" ON "MentorSession"("assignmentId", "scheduledAt");

-- CreateIndex
CREATE INDEX "OnlineExamMedia_examId_kind_idx" ON "OnlineExamMedia"("examId", "kind");

-- CreateIndex
CREATE INDEX "OnlineExamMedia_studentId_idx" ON "OnlineExamMedia"("studentId");

-- CreateIndex
CREATE INDEX "I18nString_locale_idx" ON "I18nString"("locale");

-- CreateIndex
CREATE UNIQUE INDEX "I18nString_namespace_key_locale_key" ON "I18nString"("namespace", "key", "locale");

-- CreateIndex
CREATE UNIQUE INDEX "NotificationProviderConfig_instituteId_channel_provider_key" ON "NotificationProviderConfig"("instituteId", "channel", "provider");

-- AddForeignKey
ALTER TABLE "institutes" ADD CONSTRAINT "institutes_logo_file_id_fkey" FOREIGN KEY ("logo_file_id") REFERENCES "file_objects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campuses" ADD CONSTRAINT "campuses_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "schools" ADD CONSTRAINT "schools_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "schools" ADD CONSTRAINT "schools_campus_id_fkey" FOREIGN KEY ("campus_id") REFERENCES "campuses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "schools" ADD CONSTRAINT "schools_dean_user_id_fkey" FOREIGN KEY ("dean_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "departments" ADD CONSTRAINT "departments_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "departments" ADD CONSTRAINT "departments_campus_id_fkey" FOREIGN KEY ("campus_id") REFERENCES "campuses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "departments" ADD CONSTRAINT "departments_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "schools"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "departments" ADD CONSTRAINT "departments_hod_user_id_fkey" FOREIGN KEY ("hod_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_avatar_file_id_fkey" FOREIGN KEY ("avatar_file_id") REFERENCES "file_objects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "roles" ADD CONSTRAINT "roles_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_permission_id_fkey" FOREIGN KEY ("permission_id") REFERENCES "permissions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_granted_by_id_fkey" FOREIGN KEY ("granted_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_scopes" ADD CONSTRAINT "user_scopes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_scopes" ADD CONSTRAINT "user_scopes_granted_by_id_fkey" FOREIGN KEY ("granted_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "auth_credentials" ADD CONSTRAINT "auth_credentials_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "login_attempts" ADD CONSTRAINT "login_attempts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mfa_factors" ADD CONSTRAINT "mfa_factors_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "password_reset_tokens" ADD CONSTRAINT "password_reset_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "email_verification_tokens" ADD CONSTRAINT "email_verification_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "security_events" ADD CONSTRAINT "security_events_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_actor_user_id_fkey" FOREIGN KEY ("actor_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workflow_definitions" ADD CONSTRAINT "workflow_definitions_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workflow_steps" ADD CONSTRAINT "workflow_steps_workflow_id_fkey" FOREIGN KEY ("workflow_id") REFERENCES "workflow_definitions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workflow_instances" ADD CONSTRAINT "workflow_instances_workflow_id_fkey" FOREIGN KEY ("workflow_id") REFERENCES "workflow_definitions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workflow_instances" ADD CONSTRAINT "workflow_instances_initiator_user_id_fkey" FOREIGN KEY ("initiator_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workflow_actions" ADD CONSTRAINT "workflow_actions_instance_id_fkey" FOREIGN KEY ("instance_id") REFERENCES "workflow_instances"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workflow_actions" ADD CONSTRAINT "workflow_actions_step_id_fkey" FOREIGN KEY ("step_id") REFERENCES "workflow_steps"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workflow_actions" ADD CONSTRAINT "workflow_actions_actor_user_id_fkey" FOREIGN KEY ("actor_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_recipient_id_fkey" FOREIGN KEY ("recipient_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_preferences" ADD CONSTRAINT "notification_preferences_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "file_objects" ADD CONSTRAINT "file_objects_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "file_objects" ADD CONSTRAINT "file_objects_uploaded_by_id_fkey" FOREIGN KEY ("uploaded_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "file_access_grants" ADD CONSTRAINT "file_access_grants_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "file_objects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "file_access_grants" ADD CONSTRAINT "file_access_grants_granted_to_id_fkey" FOREIGN KEY ("granted_to_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "file_access_grants" ADD CONSTRAINT "file_access_grants_granted_by_id_fkey" FOREIGN KEY ("granted_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "settings" ADD CONSTRAINT "settings_updated_by_id_fkey" FOREIGN KEY ("updated_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "settings" ADD CONSTRAINT "fk_setting_institute_scope" FOREIGN KEY ("scope_id") REFERENCES "institutes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "academic_years" ADD CONSTRAINT "academic_years_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "terms" ADD CONSTRAINT "terms_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "terms" ADD CONSTRAINT "terms_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "programs" ADD CONSTRAINT "programs_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "programs" ADD CONSTRAINT "programs_campus_id_fkey" FOREIGN KEY ("campus_id") REFERENCES "campuses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "programs" ADD CONSTRAINT "programs_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "schools"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "programs" ADD CONSTRAINT "programs_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "batches" ADD CONSTRAINT "batches_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "batches" ADD CONSTRAINT "batches_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "batches" ADD CONSTRAINT "batches_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sections" ADD CONSTRAINT "sections_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sections" ADD CONSTRAINT "sections_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "batches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sections" ADD CONSTRAINT "sections_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "terms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sections" ADD CONSTRAINT "sections_class_rep_user_id_fkey" FOREIGN KEY ("class_rep_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sections" ADD CONSTRAINT "sections_class_advisor_faculty_id_fkey" FOREIGN KEY ("class_advisor_faculty_id") REFERENCES "faculty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subjects" ADD CONSTRAINT "subjects_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subjects" ADD CONSTRAINT "subjects_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subjects" ADD CONSTRAINT "subjects_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subjects" ADD CONSTRAINT "subjects_syllabus_file_id_fkey" FOREIGN KEY ("syllabus_file_id") REFERENCES "file_objects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subject_prerequisites" ADD CONSTRAINT "subject_prerequisites_subject_id_fkey" FOREIGN KEY ("subject_id") REFERENCES "subjects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subject_prerequisites" ADD CONSTRAINT "subject_prerequisites_prerequisite_id_fkey" FOREIGN KEY ("prerequisite_id") REFERENCES "subjects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subject_offerings" ADD CONSTRAINT "subject_offerings_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subject_offerings" ADD CONSTRAINT "subject_offerings_subject_id_fkey" FOREIGN KEY ("subject_id") REFERENCES "subjects"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subject_offerings" ADD CONSTRAINT "subject_offerings_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "terms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subject_offerings" ADD CONSTRAINT "subject_offerings_section_id_fkey" FOREIGN KEY ("section_id") REFERENCES "sections"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subject_offerings" ADD CONSTRAINT "subject_offerings_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subject_offerings" ADD CONSTRAINT "subject_offerings_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subject_offerings" ADD CONSTRAINT "subject_offerings_syllabus_file_id_fkey" FOREIGN KEY ("syllabus_file_id") REFERENCES "file_objects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty" ADD CONSTRAINT "faculty_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty" ADD CONSTRAINT "faculty_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty" ADD CONSTRAINT "faculty_campus_id_fkey" FOREIGN KEY ("campus_id") REFERENCES "campuses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty" ADD CONSTRAINT "faculty_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "schools"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty" ADD CONSTRAINT "faculty_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty" ADD CONSTRAINT "faculty_reports_to_faculty_id_fkey" FOREIGN KEY ("reports_to_faculty_id") REFERENCES "faculty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty" ADD CONSTRAINT "faculty_profile_photo_file_id_fkey" FOREIGN KEY ("profile_photo_file_id") REFERENCES "file_objects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty_assignments" ADD CONSTRAINT "faculty_assignments_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty_assignments" ADD CONSTRAINT "faculty_assignments_faculty_id_fkey" FOREIGN KEY ("faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty_assignments" ADD CONSTRAINT "faculty_assignments_subject_offering_id_fkey" FOREIGN KEY ("subject_offering_id") REFERENCES "subject_offerings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty_assignments" ADD CONSTRAINT "faculty_assignments_assigned_by_user_id_fkey" FOREIGN KEY ("assigned_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty_assignments" ADD CONSTRAINT "faculty_assignments_approved_by_user_id_fkey" FOREIGN KEY ("approved_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mentorships" ADD CONSTRAINT "mentorships_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mentorships" ADD CONSTRAINT "mentorships_mentor_faculty_id_fkey" FOREIGN KEY ("mentor_faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mentorships" ADD CONSTRAINT "mentorships_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mentorships" ADD CONSTRAINT "mentorships_assigned_by_user_id_fkey" FOREIGN KEY ("assigned_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mentorships" ADD CONSTRAINT "mentorships_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty_advisors" ADD CONSTRAINT "faculty_advisors_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty_advisors" ADD CONSTRAINT "faculty_advisors_faculty_id_fkey" FOREIGN KEY ("faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty_advisors" ADD CONSTRAINT "faculty_advisors_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty_advisors" ADD CONSTRAINT "faculty_advisors_assigned_by_user_id_fkey" FOREIGN KEY ("assigned_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "advisor_students" ADD CONSTRAINT "advisor_students_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "advisor_students" ADD CONSTRAINT "advisor_students_faculty_advisor_id_fkey" FOREIGN KEY ("faculty_advisor_id") REFERENCES "faculty_advisors"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "advisor_students" ADD CONSTRAINT "advisor_students_advisor_faculty_id_fkey" FOREIGN KEY ("advisor_faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "advisor_students" ADD CONSTRAINT "advisor_students_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "advisor_students" ADD CONSTRAINT "advisor_students_assigned_by_user_id_fkey" FOREIGN KEY ("assigned_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "advisor_students" ADD CONSTRAINT "advisor_students_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "students_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "students_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "students_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "students_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "batches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "students_section_id_fkey" FOREIGN KEY ("section_id") REFERENCES "sections"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rooms" ADD CONSTRAINT "rooms_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rooms" ADD CONSTRAINT "rooms_campus_id_fkey" FOREIGN KEY ("campus_id") REFERENCES "campuses"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "labs" ADD CONSTRAINT "labs_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "labs" ADD CONSTRAINT "labs_campus_id_fkey" FOREIGN KEY ("campus_id") REFERENCES "campuses"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "time_slots" ADD CONSTRAINT "time_slots_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetables" ADD CONSTRAINT "timetables_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetables" ADD CONSTRAINT "timetables_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "terms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetables" ADD CONSTRAINT "timetables_section_id_fkey" FOREIGN KEY ("section_id") REFERENCES "sections"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetables" ADD CONSTRAINT "timetables_published_by_id_fkey" FOREIGN KEY ("published_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_entries" ADD CONSTRAINT "timetable_entries_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_entries" ADD CONSTRAINT "timetable_entries_timetable_id_fkey" FOREIGN KEY ("timetable_id") REFERENCES "timetables"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_entries" ADD CONSTRAINT "timetable_entries_subject_offering_id_fkey" FOREIGN KEY ("subject_offering_id") REFERENCES "subject_offerings"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_entries" ADD CONSTRAINT "timetable_entries_faculty_assignment_id_fkey" FOREIGN KEY ("faculty_assignment_id") REFERENCES "faculty_assignments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_entries" ADD CONSTRAINT "timetable_entries_primary_faculty_id_fkey" FOREIGN KEY ("primary_faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_entries" ADD CONSTRAINT "timetable_entries_time_slot_id_fkey" FOREIGN KEY ("time_slot_id") REFERENCES "time_slots"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_entries" ADD CONSTRAINT "timetable_entries_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "rooms"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "timetable_entries" ADD CONSTRAINT "timetable_entries_lab_id_fkey" FOREIGN KEY ("lab_id") REFERENCES "labs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_sessions" ADD CONSTRAINT "class_sessions_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_sessions" ADD CONSTRAINT "class_sessions_timetable_entry_id_fkey" FOREIGN KEY ("timetable_entry_id") REFERENCES "timetable_entries"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_sessions" ADD CONSTRAINT "class_sessions_subject_offering_id_fkey" FOREIGN KEY ("subject_offering_id") REFERENCES "subject_offerings"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_sessions" ADD CONSTRAINT "class_sessions_faculty_id_fkey" FOREIGN KEY ("faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_sessions" ADD CONSTRAINT "class_sessions_section_id_fkey" FOREIGN KEY ("section_id") REFERENCES "sections"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_sessions" ADD CONSTRAINT "class_sessions_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "rooms"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_sessions" ADD CONSTRAINT "class_sessions_lab_id_fkey" FOREIGN KEY ("lab_id") REFERENCES "labs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "class_sessions" ADD CONSTRAINT "class_sessions_rescheduled_to_id_fkey" FOREIGN KEY ("rescheduled_to_id") REFERENCES "class_sessions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty_workloads" ADD CONSTRAINT "faculty_workloads_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty_workloads" ADD CONSTRAINT "faculty_workloads_faculty_id_fkey" FOREIGN KEY ("faculty_id") REFERENCES "faculty"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculty_workloads" ADD CONSTRAINT "faculty_workloads_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "terms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses" ADD CONSTRAINT "courses_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses" ADD CONSTRAINT "courses_subject_offering_id_fkey" FOREIGN KEY ("subject_offering_id") REFERENCES "subject_offerings"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses" ADD CONSTRAINT "courses_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "terms"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses" ADD CONSTRAINT "courses_owner_faculty_id_fkey" FOREIGN KEY ("owner_faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_enrollments" ADD CONSTRAINT "course_enrollments_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_enrollments" ADD CONSTRAINT "course_enrollments_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_enrollments" ADD CONSTRAINT "course_enrollments_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_modules" ADD CONSTRAINT "course_modules_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_modules" ADD CONSTRAINT "course_modules_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_modules" ADD CONSTRAINT "course_modules_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "course_modules"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_sessions" ADD CONSTRAINT "lms_sessions_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lms_sessions" ADD CONSTRAINT "lms_sessions_module_id_fkey" FOREIGN KEY ("module_id") REFERENCES "course_modules"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "resources" ADD CONSTRAINT "resources_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "resources" ADD CONSTRAINT "resources_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "resources" ADD CONSTRAINT "resources_module_id_fkey" FOREIGN KEY ("module_id") REFERENCES "course_modules"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "resources" ADD CONSTRAINT "resources_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "lms_sessions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "resources" ADD CONSTRAINT "resources_file_object_id_fkey" FOREIGN KEY ("file_object_id") REFERENCES "file_objects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "resources" ADD CONSTRAINT "resources_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "discussion_threads" ADD CONSTRAINT "discussion_threads_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "discussion_threads" ADD CONSTRAINT "discussion_threads_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "discussion_threads" ADD CONSTRAINT "discussion_threads_author_user_id_fkey" FOREIGN KEY ("author_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "discussion_comments" ADD CONSTRAINT "discussion_comments_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "discussion_comments" ADD CONSTRAINT "discussion_comments_thread_id_fkey" FOREIGN KEY ("thread_id") REFERENCES "discussion_threads"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "discussion_comments" ADD CONSTRAINT "discussion_comments_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "discussion_comments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "discussion_comments" ADD CONSTRAINT "discussion_comments_author_user_id_fkey" FOREIGN KEY ("author_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_sessions" ADD CONSTRAINT "attendance_sessions_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_sessions" ADD CONSTRAINT "attendance_sessions_class_session_id_fkey" FOREIGN KEY ("class_session_id") REFERENCES "class_sessions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_sessions" ADD CONSTRAINT "attendance_sessions_subject_offering_id_fkey" FOREIGN KEY ("subject_offering_id") REFERENCES "subject_offerings"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_sessions" ADD CONSTRAINT "attendance_sessions_section_id_fkey" FOREIGN KEY ("section_id") REFERENCES "sections"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_sessions" ADD CONSTRAINT "attendance_sessions_faculty_id_fkey" FOREIGN KEY ("faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_records" ADD CONSTRAINT "attendance_records_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_records" ADD CONSTRAINT "attendance_records_attendance_session_id_fkey" FOREIGN KEY ("attendance_session_id") REFERENCES "attendance_sessions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_records" ADD CONSTRAINT "attendance_records_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_records" ADD CONSTRAINT "attendance_records_marked_by_user_id_fkey" FOREIGN KEY ("marked_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_categories" ADD CONSTRAINT "assignment_categories_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_categories" ADD CONSTRAINT "assignment_categories_subject_offering_id_fkey" FOREIGN KEY ("subject_offering_id") REFERENCES "subject_offerings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_categories" ADD CONSTRAINT "assignment_categories_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignments" ADD CONSTRAINT "assignments_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignments" ADD CONSTRAINT "assignments_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignments" ADD CONSTRAINT "assignments_subject_offering_id_fkey" FOREIGN KEY ("subject_offering_id") REFERENCES "subject_offerings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignments" ADD CONSTRAINT "assignments_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "assignment_categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignments" ADD CONSTRAINT "assignments_created_by_faculty_id_fkey" FOREIGN KEY ("created_by_faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_submissions" ADD CONSTRAINT "assignment_submissions_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_submissions" ADD CONSTRAINT "assignment_submissions_assignment_id_fkey" FOREIGN KEY ("assignment_id") REFERENCES "assignments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_submissions" ADD CONSTRAINT "assignment_submissions_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_submissions" ADD CONSTRAINT "assignment_submissions_graded_by_faculty_id_fkey" FOREIGN KEY ("graded_by_faculty_id") REFERENCES "faculty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quiz_banks" ADD CONSTRAINT "quiz_banks_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quiz_banks" ADD CONSTRAINT "quiz_banks_subject_id_fkey" FOREIGN KEY ("subject_id") REFERENCES "subjects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quiz_banks" ADD CONSTRAINT "quiz_banks_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quiz_banks" ADD CONSTRAINT "quiz_banks_owner_faculty_id_fkey" FOREIGN KEY ("owner_faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quiz_questions" ADD CONSTRAINT "quiz_questions_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quiz_questions" ADD CONSTRAINT "quiz_questions_quiz_bank_id_fkey" FOREIGN KEY ("quiz_bank_id") REFERENCES "quiz_banks"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quizzes" ADD CONSTRAINT "quizzes_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quizzes" ADD CONSTRAINT "quizzes_quiz_bank_id_fkey" FOREIGN KEY ("quiz_bank_id") REFERENCES "quiz_banks"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quizzes" ADD CONSTRAINT "quizzes_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quizzes" ADD CONSTRAINT "quizzes_subject_offering_id_fkey" FOREIGN KEY ("subject_offering_id") REFERENCES "subject_offerings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quizzes" ADD CONSTRAINT "quizzes_created_by_faculty_id_fkey" FOREIGN KEY ("created_by_faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quiz_attempts" ADD CONSTRAINT "quiz_attempts_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quiz_attempts" ADD CONSTRAINT "quiz_attempts_quiz_id_fkey" FOREIGN KEY ("quiz_id") REFERENCES "quizzes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quiz_attempts" ADD CONSTRAINT "quiz_attempts_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quiz_results" ADD CONSTRAINT "quiz_results_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quiz_results" ADD CONSTRAINT "quiz_results_attempt_id_fkey" FOREIGN KEY ("attempt_id") REFERENCES "quiz_attempts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "quiz_results" ADD CONSTRAINT "quiz_results_graded_by_user_id_fkey" FOREIGN KEY ("graded_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams" ADD CONSTRAINT "exams_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams" ADD CONSTRAINT "exams_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "terms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams" ADD CONSTRAINT "exams_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exams" ADD CONSTRAINT "exams_controller_user_id_fkey" FOREIGN KEY ("controller_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exam_schedules" ADD CONSTRAINT "exam_schedules_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exam_schedules" ADD CONSTRAINT "exam_schedules_exam_id_fkey" FOREIGN KEY ("exam_id") REFERENCES "exams"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exam_schedules" ADD CONSTRAINT "exam_schedules_subject_offering_id_fkey" FOREIGN KEY ("subject_offering_id") REFERENCES "subject_offerings"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exam_schedules" ADD CONSTRAINT "exam_schedules_section_id_fkey" FOREIGN KEY ("section_id") REFERENCES "sections"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exam_schedules" ADD CONSTRAINT "exam_schedules_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "rooms"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invigilation_assignments" ADD CONSTRAINT "invigilation_assignments_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invigilation_assignments" ADD CONSTRAINT "invigilation_assignments_exam_schedule_id_fkey" FOREIGN KEY ("exam_schedule_id") REFERENCES "exam_schedules"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invigilation_assignments" ADD CONSTRAINT "invigilation_assignments_faculty_id_fkey" FOREIGN KEY ("faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invigilation_assignments" ADD CONSTRAINT "invigilation_assignments_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "rooms"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hall_tickets" ADD CONSTRAINT "hall_tickets_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hall_tickets" ADD CONSTRAINT "hall_tickets_exam_id_fkey" FOREIGN KEY ("exam_id") REFERENCES "exams"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hall_tickets" ADD CONSTRAINT "hall_tickets_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hall_tickets" ADD CONSTRAINT "hall_tickets_file_object_id_fkey" FOREIGN KEY ("file_object_id") REFERENCES "file_objects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "marks_entries" ADD CONSTRAINT "marks_entries_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "marks_entries" ADD CONSTRAINT "marks_entries_exam_id_fkey" FOREIGN KEY ("exam_id") REFERENCES "exams"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "marks_entries" ADD CONSTRAINT "marks_entries_subject_offering_id_fkey" FOREIGN KEY ("subject_offering_id") REFERENCES "subject_offerings"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "marks_entries" ADD CONSTRAINT "marks_entries_entered_by_faculty_id_fkey" FOREIGN KEY ("entered_by_faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "marks_entries" ADD CONSTRAINT "marks_entries_approved_by_user_id_fkey" FOREIGN KEY ("approved_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "moderations" ADD CONSTRAINT "moderations_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "moderations" ADD CONSTRAINT "moderations_marks_entry_id_fkey" FOREIGN KEY ("marks_entry_id") REFERENCES "marks_entries"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "moderations" ADD CONSTRAINT "moderations_moderator_user_id_fkey" FOREIGN KEY ("moderator_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "results" ADD CONSTRAINT "results_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "results" ADD CONSTRAINT "results_exam_id_fkey" FOREIGN KEY ("exam_id") REFERENCES "exams"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "results" ADD CONSTRAINT "results_subject_offering_id_fkey" FOREIGN KEY ("subject_offering_id") REFERENCES "subject_offerings"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "results" ADD CONSTRAINT "results_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transcripts" ADD CONSTRAINT "transcripts_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transcripts" ADD CONSTRAINT "transcripts_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transcripts" ADD CONSTRAINT "transcripts_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "terms"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transcripts" ADD CONSTRAINT "transcripts_issued_by_user_id_fkey" FOREIGN KEY ("issued_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transcripts" ADD CONSTRAINT "transcripts_file_object_id_fkey" FOREIGN KEY ("file_object_id") REFERENCES "file_objects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "revaluation_requests" ADD CONSTRAINT "revaluation_requests_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "revaluation_requests" ADD CONSTRAINT "revaluation_requests_exam_id_fkey" FOREIGN KEY ("exam_id") REFERENCES "exams"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "revaluation_requests" ADD CONSTRAINT "revaluation_requests_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "results"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "revaluation_requests" ADD CONSTRAINT "revaluation_requests_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "revaluation_requests" ADD CONSTRAINT "revaluation_requests_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "invoices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "revaluation_requests" ADD CONSTRAINT "revaluation_requests_decided_by_user_id_fkey" FOREIGN KEY ("decided_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "registration_cycles" ADD CONSTRAINT "registration_cycles_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "registration_cycles" ADD CONSTRAINT "registration_cycles_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "terms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_registrations" ADD CONSTRAINT "course_registrations_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_registrations" ADD CONSTRAINT "course_registrations_cycle_id_fkey" FOREIGN KEY ("cycle_id") REFERENCES "registration_cycles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_registrations" ADD CONSTRAINT "course_registrations_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_registrations" ADD CONSTRAINT "course_registrations_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "terms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_registrations" ADD CONSTRAINT "course_registrations_advisor_user_id_fkey" FOREIGN KEY ("advisor_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_registrations" ADD CONSTRAINT "course_registrations_hod_user_id_fkey" FOREIGN KEY ("hod_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "registration_subjects" ADD CONSTRAINT "registration_subjects_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "registration_subjects" ADD CONSTRAINT "registration_subjects_registration_id_fkey" FOREIGN KEY ("registration_id") REFERENCES "course_registrations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "registration_subjects" ADD CONSTRAINT "registration_subjects_subject_offering_id_fkey" FOREIGN KEY ("subject_offering_id") REFERENCES "subject_offerings"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fee_structures" ADD CONSTRAINT "fee_structures_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fee_structures" ADD CONSTRAINT "fee_structures_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fee_structures" ADD CONSTRAINT "fee_structures_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "batches"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fee_structures" ADD CONSTRAINT "fee_structures_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fee_structures" ADD CONSTRAINT "fee_structures_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "terms"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_fee_structure_id_fkey" FOREIGN KEY ("fee_structure_id") REFERENCES "fee_structures"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "terms"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "invoices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_received_by_user_id_fkey" FOREIGN KEY ("received_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "scholarships" ADD CONSTRAINT "scholarships_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "scholarships" ADD CONSTRAINT "scholarships_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "scholarships" ADD CONSTRAINT "scholarships_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "scholarships" ADD CONSTRAINT "scholarships_approved_by_user_id_fkey" FOREIGN KEY ("approved_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallets" ADD CONSTRAINT "wallets_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallets" ADD CONSTRAINT "wallets_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_transactions" ADD CONSTRAINT "wallet_transactions_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_transactions" ADD CONSTRAINT "wallet_transactions_wallet_id_fkey" FOREIGN KEY ("wallet_id") REFERENCES "wallets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_transactions" ADD CONSTRAINT "wallet_transactions_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "payments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_transactions" ADD CONSTRAINT "wallet_transactions_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fee_waivers" ADD CONSTRAINT "fee_waivers_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fee_waivers" ADD CONSTRAINT "fee_waivers_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fee_waivers" ADD CONSTRAINT "fee_waivers_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "invoices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fee_waivers" ADD CONSTRAINT "fee_waivers_requested_by_user_id_fkey" FOREIGN KEY ("requested_by_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fee_waivers" ADD CONSTRAINT "fee_waivers_approved_by_user_id_fkey" FOREIGN KEY ("approved_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_owner_user_id_fkey" FOREIGN KEY ("owner_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_file_object_id_fkey" FOREIGN KEY ("file_object_id") REFERENCES "file_objects"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "certificates" ADD CONSTRAINT "certificates_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "certificates" ADD CONSTRAINT "certificates_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "certificates" ADD CONSTRAINT "certificates_issued_by_user_id_fkey" FOREIGN KEY ("issued_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "certificates" ADD CONSTRAINT "certificates_file_object_id_fkey" FOREIGN KEY ("file_object_id") REFERENCES "file_objects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "help_center_articles" ADD CONSTRAINT "help_center_articles_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "help_center_articles" ADD CONSTRAINT "help_center_articles_author_user_id_fkey" FOREIGN KEY ("author_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_raised_by_user_id_fkey" FOREIGN KEY ("raised_by_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_assigned_to_user_id_fkey" FOREIGN KEY ("assigned_to_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "books" ADD CONSTRAINT "books_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_copies" ADD CONSTRAINT "book_copies_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_copies" ADD CONSTRAINT "book_copies_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "books"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_issues" ADD CONSTRAINT "book_issues_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_issues" ADD CONSTRAINT "book_issues_book_copy_id_fkey" FOREIGN KEY ("book_copy_id") REFERENCES "book_copies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_issues" ADD CONSTRAINT "book_issues_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_issues" ADD CONSTRAINT "book_issues_borrower_user_id_fkey" FOREIGN KEY ("borrower_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_issues" ADD CONSTRAINT "book_issues_issued_by_user_id_fkey" FOREIGN KEY ("issued_by_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_issues" ADD CONSTRAINT "book_issues_returned_by_user_id_fkey" FOREIGN KEY ("returned_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_reservations" ADD CONSTRAINT "book_reservations_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_reservations" ADD CONSTRAINT "book_reservations_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "books"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_reservations" ADD CONSTRAINT "book_reservations_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_reservations" ADD CONSTRAINT "book_reservations_reserved_by_user_id_fkey" FOREIGN KEY ("reserved_by_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_fines" ADD CONSTRAINT "library_fines_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_fines" ADD CONSTRAINT "library_fines_book_issue_id_fkey" FOREIGN KEY ("book_issue_id") REFERENCES "book_issues"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_fines" ADD CONSTRAINT "library_fines_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_fines" ADD CONSTRAINT "library_fines_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "library_fines" ADD CONSTRAINT "library_fines_waived_by_user_id_fkey" FOREIGN KEY ("waived_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostels" ADD CONSTRAINT "hostels_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostels" ADD CONSTRAINT "hostels_campus_id_fkey" FOREIGN KEY ("campus_id") REFERENCES "campuses"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostels" ADD CONSTRAINT "hostels_warden_user_id_fkey" FOREIGN KEY ("warden_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_rooms" ADD CONSTRAINT "hostel_rooms_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_rooms" ADD CONSTRAINT "hostel_rooms_hostel_id_fkey" FOREIGN KEY ("hostel_id") REFERENCES "hostels"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_allocations" ADD CONSTRAINT "hostel_allocations_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_allocations" ADD CONSTRAINT "hostel_allocations_hostel_id_fkey" FOREIGN KEY ("hostel_id") REFERENCES "hostels"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_allocations" ADD CONSTRAINT "hostel_allocations_hostel_room_id_fkey" FOREIGN KEY ("hostel_room_id") REFERENCES "hostel_rooms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_allocations" ADD CONSTRAINT "hostel_allocations_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_allocations" ADD CONSTRAINT "hostel_allocations_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_allocations" ADD CONSTRAINT "hostel_allocations_allocated_by_user_id_fkey" FOREIGN KEY ("allocated_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_leave_requests" ADD CONSTRAINT "hostel_leave_requests_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_leave_requests" ADD CONSTRAINT "hostel_leave_requests_hostel_id_fkey" FOREIGN KEY ("hostel_id") REFERENCES "hostels"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_leave_requests" ADD CONSTRAINT "hostel_leave_requests_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hostel_leave_requests" ADD CONSTRAINT "hostel_leave_requests_approved_by_user_id_fkey" FOREIGN KEY ("approved_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transport_routes" ADD CONSTRAINT "transport_routes_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transport_vehicles" ADD CONSTRAINT "transport_vehicles_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transport_vehicles" ADD CONSTRAINT "transport_vehicles_route_id_fkey" FOREIGN KEY ("route_id") REFERENCES "transport_routes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transport_stops" ADD CONSTRAINT "transport_stops_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transport_stops" ADD CONSTRAINT "transport_stops_route_id_fkey" FOREIGN KEY ("route_id") REFERENCES "transport_routes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transport_passes" ADD CONSTRAINT "transport_passes_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transport_passes" ADD CONSTRAINT "transport_passes_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transport_passes" ADD CONSTRAINT "transport_passes_route_id_fkey" FOREIGN KEY ("route_id") REFERENCES "transport_routes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transport_passes" ADD CONSTRAINT "transport_passes_stop_id_fkey" FOREIGN KEY ("stop_id") REFERENCES "transport_stops"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transport_passes" ADD CONSTRAINT "transport_passes_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "clubs" ADD CONSTRAINT "clubs_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "clubs" ADD CONSTRAINT "clubs_faculty_advisor_faculty_id_fkey" FOREIGN KEY ("faculty_advisor_faculty_id") REFERENCES "faculty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "clubs" ADD CONSTRAINT "clubs_president_user_id_fkey" FOREIGN KEY ("president_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "club_memberships" ADD CONSTRAINT "club_memberships_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "club_memberships" ADD CONSTRAINT "club_memberships_club_id_fkey" FOREIGN KEY ("club_id") REFERENCES "clubs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "club_memberships" ADD CONSTRAINT "club_memberships_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_club_id_fkey" FOREIGN KEY ("club_id") REFERENCES "clubs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_organizer_user_id_fkey" FOREIGN KEY ("organizer_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_registrations" ADD CONSTRAINT "event_registrations_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_registrations" ADD CONSTRAINT "event_registrations_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_registrations" ADD CONSTRAINT "event_registrations_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_registrations" ADD CONSTRAINT "event_registrations_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feedback" ADD CONSTRAINT "feedback_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feedback" ADD CONSTRAINT "feedback_submitted_by_user_id_fkey" FOREIGN KEY ("submitted_by_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feedback" ADD CONSTRAINT "feedback_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feedback" ADD CONSTRAINT "feedback_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "terms"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "companies" ADD CONSTRAINT "companies_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_drives" ADD CONSTRAINT "placement_drives_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_drives" ADD CONSTRAINT "placement_drives_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_drives" ADD CONSTRAINT "placement_drives_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_drives" ADD CONSTRAINT "placement_drives_coordinator_user_id_fkey" FOREIGN KEY ("coordinator_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_applications" ADD CONSTRAINT "placement_applications_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_applications" ADD CONSTRAINT "placement_applications_drive_id_fkey" FOREIGN KEY ("drive_id") REFERENCES "placement_drives"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_applications" ADD CONSTRAINT "placement_applications_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_applications" ADD CONSTRAINT "placement_applications_resume_file_object_id_fkey" FOREIGN KEY ("resume_file_object_id") REFERENCES "file_objects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_offers" ADD CONSTRAINT "placement_offers_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_offers" ADD CONSTRAINT "placement_offers_drive_id_fkey" FOREIGN KEY ("drive_id") REFERENCES "placement_drives"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_offers" ADD CONSTRAINT "placement_offers_application_id_fkey" FOREIGN KEY ("application_id") REFERENCES "placement_applications"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_offers" ADD CONSTRAINT "placement_offers_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_offers" ADD CONSTRAINT "placement_offers_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "placement_offers" ADD CONSTRAINT "placement_offers_offer_letter_file_object_id_fkey" FOREIGN KEY ("offer_letter_file_object_id") REFERENCES "file_objects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "research_projects" ADD CONSTRAINT "research_projects_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "research_projects" ADD CONSTRAINT "research_projects_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "research_projects" ADD CONSTRAINT "research_projects_principal_investigator_faculty_id_fkey" FOREIGN KEY ("principal_investigator_faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "publications" ADD CONSTRAINT "publications_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "publications" ADD CONSTRAINT "publications_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "research_projects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "publications" ADD CONSTRAINT "publications_primary_author_faculty_id_fkey" FOREIGN KEY ("primary_author_faculty_id") REFERENCES "faculty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "publications" ADD CONSTRAINT "publications_file_object_id_fkey" FOREIGN KEY ("file_object_id") REFERENCES "file_objects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "grants" ADD CONSTRAINT "grants_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "grants" ADD CONSTRAINT "grants_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "research_projects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "grants" ADD CONSTRAINT "grants_pi_faculty_id_fkey" FOREIGN KEY ("pi_faculty_id") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patents" ADD CONSTRAINT "patents_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "institutes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patents" ADD CONSTRAINT "patents_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "research_projects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patents" ADD CONSTRAINT "patents_primary_inventor_faculty_id_fkey" FOREIGN KEY ("primary_inventor_faculty_id") REFERENCES "faculty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patents" ADD CONSTRAINT "patents_file_object_id_fkey" FOREIGN KEY ("file_object_id") REFERENCES "file_objects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IdempotencyKey" ADD CONSTRAINT "IdempotencyKey_instituteId_fkey" FOREIGN KEY ("instituteId") REFERENCES "institutes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IdempotencyKey" ADD CONSTRAINT "IdempotencyKey_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InstituteFeatureFlag" ADD CONSTRAINT "InstituteFeatureFlag_instituteId_fkey" FOREIGN KEY ("instituteId") REFERENCES "institutes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InstituteFeatureFlag" ADD CONSTRAINT "InstituteFeatureFlag_flagId_fkey" FOREIGN KEY ("flagId") REFERENCES "FeatureFlag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ApprovalEscalation" ADD CONSTRAINT "ApprovalEscalation_instituteId_fkey" FOREIGN KEY ("instituteId") REFERENCES "institutes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ApprovalEscalation" ADD CONSTRAINT "ApprovalEscalation_instanceId_fkey" FOREIGN KEY ("instanceId") REFERENCES "workflow_instances"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ApprovalEscalation" ADD CONSTRAINT "ApprovalEscalation_resolvedById_fkey" FOREIGN KEY ("resolvedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MentorAssignment" ADD CONSTRAINT "MentorAssignment_instituteId_fkey" FOREIGN KEY ("instituteId") REFERENCES "institutes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MentorAssignment" ADD CONSTRAINT "MentorAssignment_mentorId_fkey" FOREIGN KEY ("mentorId") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MentorAssignment" ADD CONSTRAINT "MentorAssignment_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MentorSession" ADD CONSTRAINT "MentorSession_assignmentId_fkey" FOREIGN KEY ("assignmentId") REFERENCES "MentorAssignment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MentorSession" ADD CONSTRAINT "MentorSession_runByMentorId_fkey" FOREIGN KEY ("runByMentorId") REFERENCES "faculty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OnlineExamMedia" ADD CONSTRAINT "OnlineExamMedia_instituteId_fkey" FOREIGN KEY ("instituteId") REFERENCES "institutes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OnlineExamMedia" ADD CONSTRAINT "OnlineExamMedia_examId_fkey" FOREIGN KEY ("examId") REFERENCES "exams"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NotificationProviderConfig" ADD CONSTRAINT "NotificationProviderConfig_instituteId_fkey" FOREIGN KEY ("instituteId") REFERENCES "institutes"("id") ON DELETE CASCADE ON UPDATE CASCADE;
