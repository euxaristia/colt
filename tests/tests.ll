; ModuleID = 'tests'
source_filename = "tests"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%0 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [25 x ptr] }
%1 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [13 x ptr] }
%2 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [9 x ptr] }
%3 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [1 x ptr] }
%4 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [2 x ptr] }
%5 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [2 x ptr] }
%6 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [2 x ptr] }
%7 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [10 x ptr] }
%8 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [25 x ptr] }
%9 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [25 x ptr] }
%10 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [5 x ptr] }
%11 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [25 x ptr] }
%12 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [28 x ptr] }
%13 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [10 x ptr] }
%14 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [9 x ptr] }
%15 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [9 x ptr] }
%16 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [9 x ptr] }
%17 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [25 x ptr] }
%18 = type { i32, i32, i64, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i1, ptr, ptr, [17 x ptr] }
%19 = type { ptr }
%20 = type { ptr }
%21 = type { ptr }
%22 = type { ptr }

@0 = private constant %0 { i32 12, i32 16, i64 1139018605533389629, i32 0, i32 8, ptr null, ptr null, ptr null, ptr @U32_Serialise, ptr @U32_Deserialise, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [25 x ptr] [ptr @94, ptr @93, ptr @95, ptr @96, ptr @98, ptr @90, ptr @92, ptr @99, ptr @97, ptr @91, ptr @100, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @30] }
@1 = private constant %1 { i32 -1, i32 0, i64 7848372187782362154, i32 0, i32 0, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [13 x ptr] [ptr null, ptr @31, ptr null, ptr null, ptr null, ptr @32, ptr null, ptr @32, ptr @32, ptr null, ptr null, ptr null, ptr @32] }
@2 = private constant %2 { i32 13, i32 8, i64 4121416555796745523, i32 0, i32 0, ptr @20, ptr null, ptr null, ptr @"$0$16_Serialise", ptr null, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @24, ptr null, [9 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @33] }
@3 = private constant %3 { i32 3, i32 8, i64 224156590155586631, i32 0, i32 0, ptr @21, ptr null, ptr null, ptr @AmbientAuth_Serialise, ptr null, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [1 x ptr] [ptr @34] }
@4 = private constant %4 { i32 15, i32 312, i64 2990555771781700238, i32 0, i32 304, ptr null, ptr @StdStream_Trace, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StdStream_Dispatch, ptr null, i32 -1, i1 true, ptr @25, ptr null, [2 x ptr] [ptr @35, ptr @36] }
@5 = private constant %5 { i32 1, i32 304, i64 4639252283873809566, i32 0, i32 0, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Main_Dispatch, ptr null, i32 -1, i1 true, ptr @28, ptr null, [2 x ptr] [ptr @Main_runtime_override_defaults_oo, ptr @37] }
@6 = private constant %6 { i32 5, i32 32, i64 5851970689856509530, i32 0, i32 8, ptr null, ptr @String_Trace, ptr @String_SerialiseTrace, ptr @String_Serialise, ptr @String_Deserialise, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [2 x ptr] [ptr @38, ptr @39] }
@7 = private constant %7 { i32 7, i32 32, i64 8135060660710234859, i32 0, i32 8, ptr null, ptr @Array_String_val_Trace, ptr @Array_String_val_SerialiseTrace, ptr @Array_String_val_Serialise, ptr @Array_String_val_Deserialise, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [10 x ptr] [ptr @40, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @41, ptr null, ptr null, ptr @42] }
@8 = private constant %8 { i32 8, i32 16, i64 399969149820176696, i32 0, i32 8, ptr null, ptr null, ptr null, ptr @Bool_Serialise, ptr @Bool_Deserialise, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [25 x ptr] [ptr @105, ptr @101, ptr @104, ptr @102, ptr @103, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @43] }
@9 = private constant %9 { i32 16, i32 16, i64 6356976178404583306, i32 0, i32 8, ptr null, ptr null, ptr null, ptr @F64_Serialise, ptr @F64_Deserialise, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [25 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @44] }
@10 = private constant %10 { i32 19, i32 336, i64 3765485501465393127, i32 0, i32 304, ptr null, ptr @Stdin_Trace, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Stdin_Dispatch, ptr null, i32 1, i1 true, ptr @26, ptr null, [5 x ptr] [ptr @45, ptr @49, ptr @46, ptr @48, ptr @47] }
@11 = private constant %11 { i32 20, i32 16, i64 771316481207920882, i32 0, i32 8, ptr null, ptr null, ptr null, ptr @U64_Serialise, ptr @U64_Deserialise, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [25 x ptr] [ptr @106, ptr null, ptr @107, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @50] }
@12 = private constant %12 { i32 0, i32 16, i64 771016527523638713, i32 0, i32 8, ptr null, ptr null, ptr null, ptr @USize_Serialise, ptr @USize_Deserialise, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [28 x ptr] [ptr @109, ptr @130, ptr @116, ptr @108, ptr @127, ptr @118, ptr @126, ptr @129, ptr @120, ptr @115, ptr @133, ptr @112, ptr @122, ptr @117, ptr @128, ptr @111, ptr @119, ptr @113, ptr @125, ptr @124, ptr @121, ptr @114, ptr @132, ptr @131, ptr @51, ptr @123, ptr @110, ptr @134] }
@13 = private constant %13 { i32 21, i32 32, i64 5654314923058204166, i32 0, i32 8, ptr null, ptr @Array_U8_val_Trace, ptr @Array_U8_val_SerialiseTrace, ptr @Array_U8_val_Serialise, ptr @Array_U8_val_Deserialise, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [10 x ptr] [ptr @58, ptr @54, ptr @57, ptr @61, ptr @59, ptr @52, ptr @55, ptr @53, ptr @56, ptr @60] }
@14 = private constant %14 { i32 9, i32 64, i64 38155807658830253, i32 0, i32 8, ptr null, ptr @Env_Trace, ptr @Env_Trace, ptr @Env_Serialise, ptr @Env_Deserialise, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [9 x ptr] [ptr @64, ptr @62, ptr @63, ptr @63, ptr @64, ptr @63, ptr @63, ptr @64, ptr @64] }
@15 = private constant %15 { i32 11, i32 8, i64 6637518656916771930, i32 0, i32 0, ptr @22, ptr null, ptr null, ptr @None_Serialise, ptr null, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @27, ptr null, [9 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @65] }
@16 = private constant %16 { i32 17, i32 8, i64 412291322119311248, i32 0, i32 0, ptr @23, ptr null, ptr null, ptr @AsioEvent_Serialise, ptr null, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [9 x ptr] [ptr @71, ptr @73, ptr @72, ptr @70, ptr @67, ptr @69, ptr @66, ptr @68, ptr @74] }
@17 = private constant %17 { i32 4, i32 16, i64 537680212197767059, i32 0, i32 8, ptr null, ptr null, ptr null, ptr @U8_Serialise, ptr @U8_Deserialise, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [25 x ptr] [ptr @137, ptr @135, ptr @136, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @75] }
@18 = private constant %18 { i32 -1, i32 0, i64 6936754416917653679, i32 0, i32 0, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, i32 -1, i1 true, ptr @28, ptr null, [17 x ptr] [ptr @77, ptr @76, ptr @79, ptr @86, ptr @80, ptr @89, ptr @83, ptr @89, ptr @89, ptr @78, ptr @87, ptr @81, ptr @89, ptr @82, ptr @85, ptr @84, ptr @88] }
@19 = private constant [24 x ptr] [ptr @12, ptr @5, ptr null, ptr @3, ptr @17, ptr @6, ptr null, ptr @7, ptr @8, ptr @14, ptr null, ptr @15, ptr @0, ptr @2, ptr null, ptr @4, ptr @9, ptr @16, ptr null, ptr @10, ptr @11, ptr @13, ptr null, ptr null]
@20 = private constant %19 { ptr @2 }
@21 = private constant %20 { ptr @3 }
@22 = private constant %21 { ptr @15 }
@23 = private constant %22 { ptr @16 }
@24 = private unnamed_addr constant [1 x i64] [i64 4]
@25 = private unnamed_addr constant [1 x i64] [i64 2]
@26 = private unnamed_addr constant [1 x i64] [i64 1]
@27 = private unnamed_addr constant [1 x i64] [i64 8]
@28 = private unnamed_addr constant [1 x i64] zeroinitializer
@29 = private unnamed_addr constant [31 x i8] c"Error: couldn't start runtime!\00"

; Function Attrs: nofree nosync nounwind memory(none)
declare ptr @pony_ctx() local_unnamed_addr #0

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare noalias align 8 dereferenceable(304) ptr @pony_create(ptr, ptr, i1) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @pony_sendv(ptr, ptr, ptr, ptr, i1) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @pony_sendv_single(ptr, ptr, ptr, ptr, i1) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare noalias align 8 dereferenceable_or_null(32) ptr @pony_alloc(ptr, i64) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare noalias align 8 dereferenceable(32) ptr @pony_alloc_small(ptr, i32) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare noalias align 8 dereferenceable_or_null(32) ptr @pony_realloc(ptr, ptr, i64, i64) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare noalias align 8 ptr @pony_alloc_msg(i32, i32) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @pony_trace(ptr, ptr readnone) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @pony_traceknown(ptr, ptr readonly, ptr, i32) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @pony_traceunknown(ptr, ptr readonly, i32) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @pony_gc_send(ptr) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @pony_gc_recv(ptr) local_unnamed_addr #1

; Function Attrs: nounwind
declare void @pony_send_done(ptr) local_unnamed_addr #2

; Function Attrs: nounwind
declare void @pony_recv_done(ptr) local_unnamed_addr #2

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @pony_serialise_reserve(ptr, ptr readnone, i64) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare i64 @pony_serialise_offset(ptr, ptr readonly) local_unnamed_addr #1

; Function Attrs: memory(argmem: readwrite, inaccessiblemem: readwrite)
declare ptr @pony_deserialise_offset(ptr, ptr, i64) local_unnamed_addr #3

; Function Attrs: memory(argmem: readwrite, inaccessiblemem: readwrite)
declare ptr @pony_deserialise_block(ptr, i64, i64) local_unnamed_addr #3

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare i32 @pony_init(i32, ptr) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @ponyint_become(ptr, ptr) local_unnamed_addr #1

; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare i1 @pony_start(i1, ptr, ptr) local_unnamed_addr #1

; Function Attrs: nofree nounwind memory(argmem: read)
declare i32 @pony_get_exitcode() local_unnamed_addr #4

; Function Attrs: noreturn
declare void @pony_error() local_unnamed_addr #5

declare i32 @ponyint_personality_v0(...)

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #6

define dso_local void @StdStream_Dispatch(ptr readnone captures(none) %0, ptr writeonly captures(none) initializes((304, 312)) %1, ptr readonly captures(none) %2) unnamed_addr !pony.abi !2 {
  %4 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %5 = load i32, ptr %4, align 4
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %10, label %12

7:                                                ; preds = %12, %10
  %8 = phi ptr [ %11, %10 ], [ %13, %12 ]
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 304
  store ptr %8, ptr %9, align 8
  ret void

10:                                               ; preds = %3
  %11 = tail call ptr @pony_os_stderr()
  br label %7

12:                                               ; preds = %3
  %13 = tail call ptr @pony_os_stdout()
  br label %7
}

; Function Attrs: nounwind
define dso_local void @StdStream_Trace(ptr %0, ptr readonly captures(none) %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 304
  %4 = load ptr, ptr %3, align 8
  tail call void @pony_traceknown(ptr %0, ptr %4, ptr nonnull @18, i32 0)
  ret void
}

; Function Attrs: nounwind
define dso_local void @Main_Dispatch(ptr %0, ptr readnone captures(none) %1, ptr readonly captures(none) %2) unnamed_addr #2 !pony.abi !2 {
  %4 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %5 = load ptr, ptr %4, align 8
  tail call void @pony_gc_recv(ptr %0)
  tail call void @pony_traceknown(ptr %0, ptr %5, ptr nonnull @14, i32 1)
  tail call void @pony_recv_done(ptr %0)
  ret void
}

; Function Attrs: nounwind
define dso_local void @String_Trace(ptr %0, ptr readonly captures(none) %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %4 = load ptr, ptr %3, align 8
  tail call void @pony_traceknown(ptr %0, ptr %4, ptr nonnull @18, i32 0)
  ret void
}

; Function Attrs: nounwind
define dso_local void @Array_String_val_Trace(ptr %0, ptr readonly captures(none) %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %4 = load ptr, ptr %3, align 8
  tail call void @pony_trace(ptr %0, ptr %4)
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %6 = load i64, ptr %5, align 8
  %7 = icmp eq i64 %6, 0
  br i1 %7, label %14, label %8

8:                                                ; preds = %2, %8
  %9 = phi i64 [ %12, %8 ], [ 0, %2 ]
  %10 = getelementptr inbounds ptr, ptr %4, i64 %9
  %11 = load ptr, ptr %10, align 8
  tail call void @pony_traceknown(ptr %0, ptr %11, ptr nonnull @6, i32 1)
  %12 = add nuw i64 %9, 1
  %13 = icmp eq i64 %12, %6
  br i1 %13, label %14, label %8

14:                                               ; preds = %8, %2
  ret void
}

define dso_local void @Stdin_Dispatch(ptr %0, ptr %1, ptr readonly captures(none) %2) unnamed_addr personality ptr @ponyint_personality_v0 !pony.abi !2 {
  %4 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %5 = load i32, ptr %4, align 4
  switch i32 %5, label %6 [
    i32 0, label %8
    i32 4, label %16
    i32 1, label %18
  ]

6:                                                ; preds = %3
  unreachable

7:                                                ; preds = %56, %53, %52, %25, %24, %16, %8
  ret void

8:                                                ; preds = %3
  %9 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %10 = load i8, ptr %9, align 1
  %11 = getelementptr inbounds nuw i8, ptr %1, i64 304
  store ptr @22, ptr %11, align 8
  %12 = getelementptr inbounds nuw i8, ptr %1, i64 312
  store i64 32, ptr %12, align 8
  %13 = getelementptr inbounds nuw i8, ptr %1, i64 320
  store ptr null, ptr %13, align 8
  %14 = getelementptr inbounds nuw i8, ptr %1, i64 328
  %15 = and i8 %10, 1
  store i8 %15, ptr %14, align 1
  br label %7

16:                                               ; preds = %3
  %17 = tail call fastcc i1 @46(ptr nonnull dereferenceable(336) %1)
  br label %7

18:                                               ; preds = %3
  %19 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %20 = load ptr, ptr %19, align 8
  %21 = getelementptr inbounds nuw i8, ptr %2, i64 24
  %22 = load i32, ptr %21, align 4
  tail call void @pony_gc_recv(ptr %0)
  tail call void @pony_traceknown(ptr %0, ptr %20, ptr nonnull @1, i32 2)
  tail call void @pony_recv_done(ptr %0)
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %24, label %25

24:                                               ; preds = %18
  tail call void @pony_asio_event_destroy(ptr %20)
  br label %7

25:                                               ; preds = %18
  %26 = getelementptr inbounds nuw i8, ptr %1, i64 320
  %27 = load ptr, ptr %26, align 8
  %28 = icmp eq ptr %27, %20
  br i1 %28, label %29, label %7

29:                                               ; preds = %25
  %30 = and i32 %22, 16
  %31 = icmp eq i32 %30, 0
  br i1 %31, label %53, label %32

32:                                               ; preds = %29
  %33 = icmp eq ptr %20, null
  br i1 %33, label %35, label %34

34:                                               ; preds = %32
  tail call void @pony_asio_event_unsubscribe(ptr nonnull %27)
  store ptr null, ptr %26, align 8
  br label %35

35:                                               ; preds = %34, %32
  %36 = getelementptr inbounds nuw i8, ptr %1, i64 304
  %37 = load ptr, ptr %36, align 8
  %38 = load ptr, ptr %37, align 8
  %39 = getelementptr inbounds nuw i8, ptr %38, i64 104
  %40 = load ptr, ptr %39, align 8
  %41 = load i64, ptr %40, align 8
  %42 = and i64 %41, 16
  %43 = icmp eq i64 %42, 0
  br i1 %43, label %48, label %44

44:                                               ; preds = %35
  %45 = getelementptr inbounds nuw i8, ptr %38, i64 128
  %46 = load ptr, ptr %45, align 8
  %47 = invoke fastcc ptr %46(ptr nonnull %37)
          to label %52 unwind label %50

48:                                               ; preds = %35
  invoke void @pony_error()
          to label %49 unwind label %50

49:                                               ; preds = %48
  unreachable

50:                                               ; preds = %48, %44
  %51 = landingpad { ptr, i32 }
          catch ptr null
  br label %52

52:                                               ; preds = %50, %44
  store ptr @22, ptr %36, align 8
  br label %7

53:                                               ; preds = %29
  %54 = and i32 %22, 1
  %55 = icmp eq i32 %54, 0
  br i1 %55, label %7, label %56

56:                                               ; preds = %53
  %57 = tail call fastcc i1 @46(ptr nonnull dereferenceable(336) %1)
  br label %7
}

; Function Attrs: nounwind
define dso_local void @Stdin_Trace(ptr %0, ptr readonly captures(none) %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 304
  %4 = load ptr, ptr %3, align 8
  tail call void @pony_traceunknown(ptr %0, ptr %4, i32 0)
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 320
  %6 = load ptr, ptr %5, align 8
  tail call void @pony_traceknown(ptr %0, ptr %6, ptr nonnull @1, i32 2)
  ret void
}

; Function Attrs: nounwind
define dso_local void @Array_U8_val_Trace(ptr %0, ptr readonly captures(none) %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %4 = load ptr, ptr %3, align 8
  tail call void @pony_trace(ptr %0, ptr %4)
  ret void
}

; Function Attrs: nounwind
define dso_local void @Env_Trace(ptr %0, ptr readonly captures(none) %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %4 = load ptr, ptr %3, align 8
  tail call void @pony_traceunknown(ptr %0, ptr %4, i32 2)
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %6 = load ptr, ptr %5, align 8
  tail call void @pony_traceunknown(ptr %0, ptr %6, i32 2)
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %8 = load ptr, ptr %7, align 8
  tail call void @pony_traceunknown(ptr %0, ptr %8, i32 2)
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 40
  %10 = load ptr, ptr %9, align 8
  tail call void @pony_traceknown(ptr %0, ptr %10, ptr nonnull @7, i32 1)
  %11 = getelementptr inbounds nuw i8, ptr %1, i64 48
  %12 = load ptr, ptr %11, align 8
  tail call void @pony_traceknown(ptr %0, ptr %12, ptr nonnull @7, i32 1)
  %13 = getelementptr inbounds nuw i8, ptr %1, i64 56
  %14 = load ptr, ptr %13, align 8
  tail call void @pony_traceunknown(ptr %0, ptr %14, i32 1)
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local range(i32 -1, 22) i32 @__DescOffsetLookupFn(i64 %0) unnamed_addr #7 {
  switch i64 %0, label %2 [
    i64 1139018605533389629, label %4
    i64 4121416555796745523, label %5
    i64 224156590155586631, label %6
    i64 2990555771781700238, label %7
    i64 4639252283873809566, label %8
    i64 5851970689856509530, label %9
    i64 8135060660710234859, label %10
    i64 399969149820176696, label %11
    i64 6356976178404583306, label %12
    i64 3765485501465393127, label %13
    i64 771316481207920882, label %14
    i64 771016527523638713, label %15
    i64 5654314923058204166, label %16
    i64 38155807658830253, label %17
    i64 6637518656916771930, label %18
    i64 412291322119311248, label %19
    i64 537680212197767059, label %20
  ]

2:                                                ; preds = %1, %20, %19, %18, %17, %16, %15, %14, %13, %12, %11, %10, %9, %8, %7, %6, %5, %4
  %3 = phi i32 [ 12, %4 ], [ 13, %5 ], [ 3, %6 ], [ 15, %7 ], [ 1, %8 ], [ 5, %9 ], [ 7, %10 ], [ 8, %11 ], [ 16, %12 ], [ 19, %13 ], [ 20, %14 ], [ 0, %15 ], [ 21, %16 ], [ 9, %17 ], [ 11, %18 ], [ 17, %19 ], [ 4, %20 ], [ -1, %1 ]
  ret i32 %3

4:                                                ; preds = %1
  br label %2

5:                                                ; preds = %1
  br label %2

6:                                                ; preds = %1
  br label %2

7:                                                ; preds = %1
  br label %2

8:                                                ; preds = %1
  br label %2

9:                                                ; preds = %1
  br label %2

10:                                               ; preds = %1
  br label %2

11:                                               ; preds = %1
  br label %2

12:                                               ; preds = %1
  br label %2

13:                                               ; preds = %1
  br label %2

14:                                               ; preds = %1
  br label %2

15:                                               ; preds = %1
  br label %2

16:                                               ; preds = %1
  br label %2

17:                                               ; preds = %1
  br label %2

18:                                               ; preds = %1
  br label %2

19:                                               ; preds = %1
  br label %2

20:                                               ; preds = %1
  br label %2
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc range(i64 0, 4294967296) i64 @30(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i32, ptr %2, align 4
  %4 = zext i32 %3 to i64
  ret i64 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc noalias noundef ptr @31(ptr readnone captures(none) %0) unnamed_addr #7 !pony.abi !2 {
  ret ptr null
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc i1 @32(ptr readnone captures(address_is_null) %0) unnamed_addr #7 !pony.abi !2 {
  %2 = icmp eq ptr %0, null
  ret i1 %2
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc ptr @33(ptr readnone returned captures(ret: address, provenance) %0) unnamed_addr #7 !pony.abi !2 {
  ret ptr %0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc ptr @34(ptr readnone returned captures(ret: address, provenance) %0) unnamed_addr #7 !pony.abi !2 {
  ret ptr %0
}

; Function Attrs: nounwind
define private fastcc ptr @35(ptr returned %0) unnamed_addr #2 !pony.abi !2 {
  %2 = tail call ptr @pony_ctx()
  %3 = tail call ptr @pony_alloc_msg(i32 0, i32 0), !pony.msgsend !2
  tail call void @pony_sendv_single(ptr %2, ptr %0, ptr %3, ptr %3, i1 true), !pony.msgsend !2
  ret ptr %0
}

; Function Attrs: nounwind
define private fastcc ptr @36(ptr returned %0) unnamed_addr #2 !pony.abi !2 {
  %2 = tail call ptr @pony_ctx()
  %3 = tail call ptr @pony_alloc_msg(i32 0, i32 1), !pony.msgsend !2
  tail call void @pony_sendv_single(ptr %2, ptr %0, ptr %3, ptr %3, i1 true), !pony.msgsend !2
  ret ptr %0
}

; Function Attrs: nounwind
define private fastcc ptr @37(ptr returned %0, ptr dereferenceable(64) %1) unnamed_addr #2 !pony.abi !2 {
  %3 = tail call ptr @pony_ctx()
  %4 = tail call ptr @pony_alloc_msg(i32 0, i32 1), !pony.msgsend !2
  %5 = getelementptr inbounds nuw i8, ptr %4, i64 16
  store ptr %1, ptr %5, align 8
  tail call void @pony_gc_send(ptr %3), !pony.msgsend !2
  tail call void @pony_traceknown(ptr %3, ptr nonnull %1, ptr nonnull @14, i32 1)
  tail call void @pony_send_done(ptr %3), !pony.msgsend !2
  tail call void @pony_sendv_single(ptr %3, ptr %0, ptr %4, ptr %4, i1 true), !pony.msgsend !2
  ret ptr %0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local void @Main_runtime_override_defaults_oo(ptr readnone captures(none) %0) #7 !pony.abi !2 {
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, inaccessiblemem: none)
define private fastcc i8 @38(ptr readonly captures(none) dereferenceable(32) %0, i64 %1, i8 %2) unnamed_addr #9 !pony.abi !2 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %5 = load ptr, ptr %4, align 8
  %6 = getelementptr inbounds i8, ptr %5, i64 %1
  %7 = load i8, ptr %6, align 1
  store i8 %2, ptr %6, align 1
  ret i8 %7
}

; Function Attrs: nounwind
define private fastcc void @39(ptr captures(none) initializes((8, 32)) %0, ptr readonly captures(address_is_null) %1) unnamed_addr #2 !pony.abi !2 {
  %3 = icmp eq ptr %1, null
  br i1 %3, label %4, label %10

4:                                                ; preds = %2
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i64 0, ptr %5, align 8
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store i64 1, ptr %6, align 8
  %7 = tail call ptr @pony_ctx()
  %8 = tail call noalias align 32 dereferenceable_or_null(1) ptr @pony_alloc(ptr %7, i64 1)
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 24
  store ptr %8, ptr %9, align 8
  store i8 0, ptr %8, align 32
  br label %26

10:                                               ; preds = %2
  %11 = load i8, ptr %1, align 1
  %12 = icmp eq i8 %11, 0
  br i1 %12, label %17, label %13

13:                                               ; preds = %10
  %14 = getelementptr i8, ptr %1, i64 1
  %15 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %14)
  %16 = add i64 %15, 1
  br label %17

17:                                               ; preds = %13, %10
  %18 = phi i64 [ 0, %10 ], [ %16, %13 ]
  %19 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i64 %18, ptr %19, align 8
  %20 = add i64 %18, 1
  %21 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store i64 %20, ptr %21, align 8
  %22 = tail call ptr @pony_ctx()
  %23 = tail call noalias align 32 dereferenceable_or_null(1) ptr @pony_alloc(ptr %22, i64 %20)
  %24 = getelementptr inbounds nuw i8, ptr %0, i64 24
  store ptr %23, ptr %24, align 8
  %25 = load i64, ptr %21, align 8
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 32 %23, ptr nonnull readonly align 1 %1, i64 %25, i1 false)
  br label %26

26:                                               ; preds = %17, %4
  ret void
}

; Function Attrs: nounwind
define private fastcc noundef nonnull ptr @40(ptr captures(none) dereferenceable(32) %0, ptr dereferenceable(32) %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = add i64 %4, 1
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %7 = load i64, ptr %6, align 8
  %8 = icmp ult i64 %7, %5
  br i1 %8, label %12, label %9

9:                                                ; preds = %2
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %11 = load ptr, ptr %10, align 8
  br label %27

12:                                               ; preds = %2
  %13 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %4, i1 false)
  %14 = icmp eq i64 %13, 0
  %15 = sub nuw nsw i64 64, %13
  %16 = shl nuw i64 1, %15
  %17 = tail call i64 @llvm.umax.i64(i64 %16, i64 %5)
  %18 = select i1 %14, i64 %5, i64 %17
  %19 = tail call i64 @llvm.umax.i64(i64 %18, i64 8)
  store i64 %19, ptr %6, align 8
  %20 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %21 = load ptr, ptr %20, align 8
  %22 = tail call ptr @pony_ctx()
  %23 = shl i64 %19, 3
  %24 = shl i64 %4, 3
  %25 = tail call noalias align 32 dereferenceable_or_null(8) ptr @pony_realloc(ptr %22, ptr %21, i64 %23, i64 %24)
  store ptr %25, ptr %20, align 8
  %26 = load i64, ptr %3, align 8
  br label %27

27:                                               ; preds = %9, %12
  %28 = phi ptr [ %11, %9 ], [ %25, %12 ]
  %29 = phi i64 [ %4, %9 ], [ %26, %12 ]
  %30 = getelementptr inbounds ptr, ptr %28, i64 %29
  store ptr %1, ptr %30, align 8
  %31 = load i64, ptr %3, align 8
  %32 = add i64 %31, 1
  store i64 %32, ptr %3, align 8
  ret ptr @22
}

; Function Attrs: nounwind
define private fastcc noundef nonnull ptr @41(ptr captures(none) dereferenceable(32) %0, i64 %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %4 = load i64, ptr %3, align 8
  %5 = icmp ult i64 %4, %1
  br i1 %5, label %6, label %23

6:                                                ; preds = %2
  %7 = add i64 %1, -1
  %8 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %7, i1 false)
  %9 = icmp eq i64 %8, 0
  %10 = sub nuw nsw i64 64, %8
  %11 = shl nuw i64 1, %10
  %12 = tail call i64 @llvm.umax.i64(i64 %11, i64 %1)
  %13 = select i1 %9, i64 %1, i64 %12
  %14 = tail call i64 @llvm.umax.i64(i64 %13, i64 8)
  store i64 %14, ptr %3, align 8
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %16 = load i64, ptr %15, align 8
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %18 = load ptr, ptr %17, align 8
  %19 = tail call ptr @pony_ctx()
  %20 = shl i64 %14, 3
  %21 = shl i64 %16, 3
  %22 = tail call noalias align 32 dereferenceable_or_null(8) ptr @pony_realloc(ptr %19, ptr %18, i64 %20, i64 %21)
  store ptr %22, ptr %17, align 8
  br label %23

23:                                               ; preds = %2, %6
  ret ptr @22
}

; Function Attrs: nounwind
define private fastcc void @42(ptr writeonly captures(none) initializes((8, 32)) %0, i64 %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i64 0, ptr %3, align 8
  %4 = icmp eq i64 %1, 0
  br i1 %4, label %18, label %5

5:                                                ; preds = %2
  %6 = add i64 %1, -1
  %7 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %6, i1 false)
  %8 = icmp eq i64 %7, 0
  %9 = sub nuw nsw i64 64, %7
  %10 = shl nuw i64 1, %9
  %11 = tail call i64 @llvm.umax.i64(i64 %10, i64 %1)
  %12 = select i1 %8, i64 %1, i64 %11
  %13 = tail call i64 @llvm.umax.i64(i64 %12, i64 8)
  %14 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store i64 %13, ptr %14, align 8
  %15 = tail call ptr @pony_ctx()
  %16 = shl i64 %13, 3
  %17 = tail call noalias align 32 dereferenceable_or_null(8) ptr @pony_alloc(ptr %15, i64 %16)
  br label %20

18:                                               ; preds = %2
  %19 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store i64 0, ptr %19, align 8
  br label %20

20:                                               ; preds = %18, %5
  %21 = phi ptr [ null, %18 ], [ %17, %5 ]
  %22 = getelementptr inbounds nuw i8, ptr %0, i64 24
  store ptr %21, ptr %22, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc range(i64 0, 2) i64 @43(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i8, ptr %2, align 1
  %4 = and i8 %3, 1
  %5 = zext nneg i8 %4 to i64
  ret i64 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @44(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  ret i64 %3
}

; Function Attrs: nounwind
define private fastcc ptr @45(ptr returned %0, i1 %1) unnamed_addr #2 !pony.abi !2 {
  %3 = tail call ptr @pony_ctx()
  %4 = zext i1 %1 to i8
  %5 = tail call ptr @pony_alloc_msg(i32 0, i32 0), !pony.msgsend !2
  %6 = getelementptr inbounds nuw i8, ptr %5, i64 16
  store i8 %4, ptr %6, align 8
  tail call void @pony_sendv_single(ptr %3, ptr %0, ptr %5, ptr %5, i1 true), !pony.msgsend !2
  ret ptr %0
}

define private fastcc noundef i1 @46(ptr dereferenceable(336) %0) unnamed_addr personality ptr @ponyint_personality_v0 !pony.abi !2 {
  %2 = tail call ptr @pony_ctx()
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 304
  %4 = load ptr, ptr %3, align 8
  %5 = load ptr, ptr %4, align 8
  %6 = getelementptr inbounds nuw i8, ptr %5, i64 104
  %7 = load ptr, ptr %6, align 8
  %8 = load i64, ptr %7, align 8
  %9 = and i64 %8, 16
  %10 = icmp eq i64 %9, 0
  br i1 %10, label %13, label %11

11:                                               ; preds = %1
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 312
  br label %15

13:                                               ; preds = %1
  invoke void @pony_error()
          to label %14 unwind label %64

14:                                               ; preds = %13
  unreachable

15:                                               ; preds = %11, %49
  %16 = phi i64 [ %56, %49 ], [ 0, %11 ]
  %17 = load i64, ptr %12, align 8
  %18 = tail call ptr @pony_alloc_small(ptr %2, i32 0)
  store ptr @13, ptr %18, align 8
  %19 = getelementptr inbounds nuw i8, ptr %18, i64 8
  %20 = icmp eq i64 %17, 0
  %21 = getelementptr inbounds nuw i8, ptr %18, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %21, i8 0, i64 16, i1 false)
  br i1 %20, label %34, label %22

22:                                               ; preds = %15
  %23 = getelementptr inbounds nuw i8, ptr %18, i64 24
  %24 = getelementptr inbounds nuw i8, ptr %18, i64 16
  %25 = add i64 %17, -1
  %26 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %25, i1 false)
  %27 = icmp eq i64 %26, 0
  %28 = sub nuw nsw i64 64, %26
  %29 = shl nuw i64 1, %28
  %30 = tail call i64 @llvm.umax.i64(i64 %29, i64 %17)
  %31 = select i1 %27, i64 %17, i64 %30
  %32 = tail call i64 @llvm.umax.i64(i64 %31, i64 8)
  store i64 %32, ptr %24, align 8
  %33 = tail call noalias align 32 dereferenceable_or_null(1) ptr @pony_realloc(ptr %2, ptr null, i64 %32, i64 0)
  store ptr %33, ptr %23, align 8
  br label %34

34:                                               ; preds = %15, %22
  %35 = phi ptr [ null, %15 ], [ %33, %22 ]
  store i64 %17, ptr %19, align 8
  %36 = tail call i64 @pony_os_stdin_read(ptr %35, i64 %17)
  switch i64 %36, label %49 [
    i64 -1, label %37
    i64 0, label %39
  ]

37:                                               ; preds = %34, %69, %64, %62, %58, %44
  %38 = phi i1 [ false, %44 ], [ true, %58 ], [ true, %62 ], [ false, %64 ], [ false, %69 ], [ true, %34 ]
  ret i1 %38

39:                                               ; preds = %34
  %40 = getelementptr inbounds nuw i8, ptr %0, i64 320
  %41 = load ptr, ptr %40, align 8
  %42 = icmp eq ptr %41, null
  br i1 %42, label %44, label %43

43:                                               ; preds = %39
  tail call void @pony_asio_event_unsubscribe(ptr nonnull %41)
  store ptr null, ptr %40, align 8
  br label %44

44:                                               ; preds = %39, %43
  %45 = load ptr, ptr %4, align 8
  %46 = getelementptr inbounds nuw i8, ptr %45, i64 128
  %47 = load ptr, ptr %46, align 8
  %48 = tail call fastcc ptr %47(ptr nonnull %4)
  store ptr @22, ptr %3, align 8
  br label %37

49:                                               ; preds = %34
  %50 = load i64, ptr %19, align 8
  %51 = tail call i64 @llvm.umin.i64(i64 %50, i64 %36)
  store i64 %51, ptr %19, align 8
  %52 = load ptr, ptr %4, align 8
  %53 = getelementptr inbounds nuw i8, ptr %52, i64 120
  %54 = load ptr, ptr %53, align 8
  %55 = tail call fastcc ptr %54(ptr nonnull %4, ptr nonnull %18)
  %56 = add i64 %36, %16
  %57 = icmp ugt i64 %56, 4096
  br i1 %57, label %58, label %15

58:                                               ; preds = %49
  %59 = getelementptr inbounds nuw i8, ptr %0, i64 328
  %60 = load i8, ptr %59, align 1
  %61 = trunc i8 %60 to i1
  br i1 %61, label %62, label %37

62:                                               ; preds = %58
  %63 = tail call ptr @pony_alloc_msg(i32 0, i32 4), !pony.msgsend !2
  tail call void @pony_sendv(ptr %2, ptr nonnull %0, ptr %63, ptr %63, i1 true), !pony.msgsend !2
  br label %37

64:                                               ; preds = %13
  %65 = landingpad { ptr, i32 }
          catch ptr null
  %66 = getelementptr inbounds nuw i8, ptr %0, i64 320
  %67 = load ptr, ptr %66, align 8
  %68 = icmp eq ptr %67, null
  br i1 %68, label %37, label %69

69:                                               ; preds = %64
  tail call void @pony_asio_event_unsubscribe(ptr nonnull %67)
  store ptr null, ptr %66, align 8
  br label %37
}

; Function Attrs: nounwind
define private fastcc noundef nonnull ptr @47(ptr dereferenceable(336) %0) unnamed_addr #2 !pony.abi !2 {
  %2 = tail call ptr @pony_ctx()
  %3 = tail call ptr @pony_alloc_msg(i32 0, i32 4), !pony.msgsend !2
  tail call void @pony_sendv(ptr %2, ptr nonnull %0, ptr %3, ptr %3, i1 true), !pony.msgsend !2
  ret ptr @22
}

define private fastcc noundef nonnull ptr @48(ptr captures(none) dereferenceable(336) %0) unnamed_addr !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 320
  %3 = load ptr, ptr %2, align 8
  %4 = icmp eq ptr %3, null
  br i1 %4, label %6, label %5

5:                                                ; preds = %1
  tail call void @pony_asio_event_unsubscribe(ptr nonnull %3)
  store ptr null, ptr %2, align 8
  br label %6

6:                                                ; preds = %1, %5
  ret ptr @22
}

; Function Attrs: nounwind
define private fastcc noundef nonnull ptr @49(ptr dereferenceable(336) %0, ptr %1, i32 %2, i32 %3) unnamed_addr #2 !pony.abi !2 {
  %5 = tail call ptr @pony_ctx()
  %6 = tail call ptr @pony_alloc_msg(i32 0, i32 1), !pony.msgsend !2
  %7 = getelementptr inbounds nuw i8, ptr %6, i64 16
  store ptr %1, ptr %7, align 8
  %8 = getelementptr inbounds nuw i8, ptr %6, i64 24
  store i32 %2, ptr %8, align 8
  %9 = getelementptr inbounds nuw i8, ptr %6, i64 28
  store i32 %3, ptr %9, align 4
  tail call void @pony_gc_send(ptr %5), !pony.msgsend !2
  tail call void @pony_traceknown(ptr %5, ptr %1, ptr nonnull @1, i32 2)
  tail call void @pony_send_done(ptr %5), !pony.msgsend !2
  tail call void @pony_sendv(ptr %5, ptr nonnull %0, ptr %6, ptr %6, i1 true), !pony.msgsend !2
  ret ptr @22
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @50(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  ret i64 %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @51(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  ret i64 %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @52(ptr readonly captures(none) dereferenceable(32) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  ret i64 %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @53(ptr readonly captures(none) dereferenceable(32) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  ret i64 %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @54(ptr readonly captures(none) dereferenceable(32) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  ret i64 %3
}

; Function Attrs: nounwind
define private fastcc noundef nonnull ptr @55(ptr captures(none) dereferenceable(32) %0, i64 %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %4 = load i64, ptr %3, align 8
  %5 = icmp ult i64 %4, %1
  br i1 %5, label %6, label %21

6:                                                ; preds = %2
  %7 = add i64 %1, -1
  %8 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %7, i1 false)
  %9 = icmp eq i64 %8, 0
  %10 = sub nuw nsw i64 64, %8
  %11 = shl nuw i64 1, %10
  %12 = tail call i64 @llvm.umax.i64(i64 %11, i64 %1)
  %13 = select i1 %9, i64 %1, i64 %12
  %14 = tail call i64 @llvm.umax.i64(i64 %13, i64 8)
  store i64 %14, ptr %3, align 8
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %16 = load i64, ptr %15, align 8
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %18 = load ptr, ptr %17, align 8
  %19 = tail call ptr @pony_ctx()
  %20 = tail call noalias align 32 dereferenceable_or_null(1) ptr @pony_realloc(ptr %19, ptr %18, i64 %14, i64 %16)
  store ptr %20, ptr %17, align 8
  br label %21

21:                                               ; preds = %2, %6
  ret ptr @22
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc ptr @56(ptr readonly captures(none) dereferenceable(32) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %4 = load ptr, ptr %3, align 8
  %5 = getelementptr inbounds i8, ptr %4, i64 %1
  ret ptr %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc ptr @57(ptr readonly captures(none) dereferenceable(32) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %4 = load ptr, ptr %3, align 8
  %5 = getelementptr inbounds i8, ptr %4, i64 %1
  ret ptr %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc ptr @58(ptr readonly captures(none) dereferenceable(32) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %4 = load ptr, ptr %3, align 8
  %5 = getelementptr inbounds i8, ptr %4, i64 %1
  ret ptr %5
}

; Function Attrs: nounwind
define private fastcc noundef nonnull ptr @59(ptr captures(none) dereferenceable(32) %0, i64 %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %4 = load i64, ptr %3, align 8
  %5 = icmp ult i64 %4, %1
  br i1 %5, label %6, label %21

6:                                                ; preds = %2
  %7 = add i64 %1, -1
  %8 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %7, i1 false)
  %9 = icmp eq i64 %8, 0
  %10 = sub nuw nsw i64 64, %8
  %11 = shl nuw i64 1, %10
  %12 = tail call i64 @llvm.umax.i64(i64 %11, i64 %1)
  %13 = select i1 %9, i64 %1, i64 %12
  %14 = tail call i64 @llvm.umax.i64(i64 %13, i64 8)
  store i64 %14, ptr %3, align 8
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %16 = load i64, ptr %15, align 8
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %18 = load ptr, ptr %17, align 8
  %19 = tail call ptr @pony_ctx()
  %20 = tail call noalias align 32 dereferenceable_or_null(1) ptr @pony_realloc(ptr %19, ptr %18, i64 %14, i64 %16)
  store ptr %20, ptr %17, align 8
  br label %21

21:                                               ; preds = %2, %6
  %22 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i64 %1, ptr %22, align 8
  ret ptr @22
}

; Function Attrs: nounwind
define private fastcc void @60(ptr writeonly captures(none) initializes((8, 32)) %0, i64 %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i64 0, ptr %3, align 8
  %4 = icmp eq i64 %1, 0
  br i1 %4, label %17, label %5

5:                                                ; preds = %2
  %6 = add i64 %1, -1
  %7 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %6, i1 false)
  %8 = icmp eq i64 %7, 0
  %9 = sub nuw nsw i64 64, %7
  %10 = shl nuw i64 1, %9
  %11 = tail call i64 @llvm.umax.i64(i64 %10, i64 %1)
  %12 = select i1 %8, i64 %1, i64 %11
  %13 = tail call i64 @llvm.umax.i64(i64 %12, i64 8)
  %14 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store i64 %13, ptr %14, align 8
  %15 = tail call ptr @pony_ctx()
  %16 = tail call noalias align 32 dereferenceable_or_null(1) ptr @pony_alloc(ptr %15, i64 %13)
  br label %19

17:                                               ; preds = %2
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store i64 0, ptr %18, align 8
  br label %19

19:                                               ; preds = %17, %5
  %20 = phi ptr [ null, %17 ], [ %16, %5 ]
  %21 = getelementptr inbounds nuw i8, ptr %0, i64 24
  store ptr %20, ptr %21, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define private fastcc noundef nonnull ptr @61(ptr captures(none) dereferenceable(32) %0, i64 %1) unnamed_addr #10 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = tail call i64 @llvm.umin.i64(i64 %4, i64 %1)
  store i64 %5, ptr %3, align 8
  ret ptr @22
}

define private fastcc void @62(ptr writeonly captures(none) initializes((8, 40)) %0, i32 %1, ptr readonly captures(none) %2, ptr readonly captures(address_is_null) %3) unnamed_addr !pony.abi !2 {
  %5 = tail call ptr @pony_ctx()
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store ptr @21, ptr %6, align 8
  tail call void @pony_os_stdout_setup()
  %7 = tail call i1 @pony_os_stdin_setup()
  %8 = tail call ptr @pony_create(ptr %5, ptr nonnull @10, i1 false)
  %9 = zext i1 %7 to i8
  %10 = tail call ptr @pony_alloc_msg(i32 0, i32 0), !pony.msgsend !2
  %11 = getelementptr inbounds nuw i8, ptr %10, i64 16
  store i8 %9, ptr %11, align 8
  tail call void @pony_sendv_single(ptr %5, ptr nonnull %8, ptr %10, ptr %10, i1 true), !pony.msgsend !2
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %8, ptr %12, align 8
  %13 = tail call ptr @pony_create(ptr %5, ptr nonnull @4, i1 false)
  %14 = tail call ptr @pony_alloc_msg(i32 0, i32 1), !pony.msgsend !2
  tail call void @pony_sendv_single(ptr %5, ptr nonnull %13, ptr %14, ptr %14, i1 true), !pony.msgsend !2
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 24
  store ptr %13, ptr %15, align 8
  %16 = tail call ptr @pony_create(ptr %5, ptr nonnull @4, i1 false)
  %17 = tail call ptr @pony_alloc_msg(i32 0, i32 0), !pony.msgsend !2
  tail call void @pony_sendv_single(ptr %5, ptr nonnull %16, ptr %17, ptr %17, i1 true), !pony.msgsend !2
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr %16, ptr %18, align 8
  %19 = zext i32 %1 to i64
  %20 = tail call fastcc ptr @64(ptr poison, ptr %2, i64 %19)
  %21 = getelementptr inbounds nuw i8, ptr %0, i64 40
  store ptr %20, ptr %21, align 8
  %22 = icmp eq ptr %3, null
  br i1 %22, label %32, label %23

23:                                               ; preds = %4
  %24 = load ptr, ptr %3, align 8
  %25 = icmp eq ptr %24, null
  br i1 %25, label %32, label %26

26:                                               ; preds = %23, %26
  %27 = phi i64 [ %28, %26 ], [ 0, %23 ]
  %28 = add i64 %27, 1
  %29 = getelementptr inbounds ptr, ptr %3, i64 %28
  %30 = load ptr, ptr %29, align 8
  %31 = icmp eq ptr %30, null
  br i1 %31, label %32, label %26

32:                                               ; preds = %26, %4, %23
  %33 = phi i64 [ 0, %4 ], [ 0, %23 ], [ %28, %26 ]
  %34 = tail call fastcc ptr @64(ptr nonnull poison, ptr %3, i64 %33)
  %35 = getelementptr inbounds nuw i8, ptr %0, i64 48
  store ptr %34, ptr %35, align 8
  %36 = getelementptr inbounds nuw i8, ptr %0, i64 56
  store ptr @20, ptr %36, align 8
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define private fastcc i64 @63(ptr readnone captures(none) %0, ptr readonly captures(address_is_null) %1) unnamed_addr #11 !pony.abi !2 {
  %3 = icmp eq ptr %1, null
  br i1 %3, label %4, label %6

4:                                                ; preds = %9, %6, %2
  %5 = phi i64 [ 0, %2 ], [ 0, %6 ], [ %11, %9 ]
  ret i64 %5

6:                                                ; preds = %2
  %7 = load ptr, ptr %1, align 8
  %8 = icmp eq ptr %7, null
  br i1 %8, label %4, label %9

9:                                                ; preds = %6, %9
  %10 = phi i64 [ %11, %9 ], [ 0, %6 ]
  %11 = add i64 %10, 1
  %12 = getelementptr inbounds ptr, ptr %1, i64 %11
  %13 = load ptr, ptr %12, align 8
  %14 = icmp eq ptr %13, null
  br i1 %14, label %4, label %9
}

; Function Attrs: nounwind
define private fastcc noalias noundef nonnull ptr @64(ptr readnone captures(none) %0, ptr readonly captures(none) %1, i64 %2) unnamed_addr #2 !pony.abi !2 {
  %4 = tail call ptr @pony_ctx()
  %5 = tail call ptr @pony_alloc_small(ptr %4, i32 0)
  store ptr @7, ptr %5, align 8
  %6 = getelementptr inbounds nuw i8, ptr %5, i64 8
  store i64 0, ptr %6, align 8
  %7 = icmp eq i64 %2, 0
  br i1 %7, label %68, label %8

8:                                                ; preds = %3
  %9 = add i64 %2, -1
  %10 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %9, i1 false)
  %11 = icmp eq i64 %10, 0
  %12 = sub nuw nsw i64 64, %10
  %13 = shl nuw i64 1, %12
  %14 = tail call i64 @llvm.umax.i64(i64 %13, i64 %2)
  %15 = select i1 %11, i64 %2, i64 %14
  %16 = tail call i64 @llvm.umax.i64(i64 %15, i64 8)
  %17 = getelementptr inbounds nuw i8, ptr %5, i64 16
  store i64 %16, ptr %17, align 8
  %18 = shl i64 %16, 3
  %19 = tail call noalias align 32 dereferenceable_or_null(8) ptr @pony_alloc(ptr %4, i64 %18)
  %20 = getelementptr inbounds nuw i8, ptr %5, i64 24
  store ptr %19, ptr %20, align 8
  br label %21

21:                                               ; preds = %8, %64
  %22 = phi ptr [ %19, %8 ], [ %65, %64 ]
  %23 = phi i64 [ 0, %8 ], [ %50, %64 ]
  %24 = phi i64 [ 0, %8 ], [ %25, %64 ]
  %25 = add nuw i64 %24, 1
  %26 = getelementptr inbounds ptr, ptr %1, i64 %24
  %27 = load ptr, ptr %26, align 8
  %28 = tail call ptr @pony_alloc_small(ptr %4, i32 0)
  store ptr @6, ptr %28, align 8
  %29 = icmp eq ptr %27, null
  br i1 %29, label %30, label %35

30:                                               ; preds = %21
  %31 = getelementptr inbounds nuw i8, ptr %28, i64 8
  store i64 0, ptr %31, align 8
  %32 = getelementptr inbounds nuw i8, ptr %28, i64 16
  store i64 1, ptr %32, align 8
  %33 = tail call noalias align 32 dereferenceable_or_null(1) ptr @pony_alloc(ptr %4, i64 1)
  %34 = getelementptr inbounds nuw i8, ptr %28, i64 24
  store ptr %33, ptr %34, align 8
  store i8 0, ptr %33, align 32
  br label %49

35:                                               ; preds = %21
  %36 = load i8, ptr %27, align 1
  %37 = icmp eq i8 %36, 0
  br i1 %37, label %42, label %38

38:                                               ; preds = %35
  %39 = getelementptr i8, ptr %27, i64 1
  %40 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %39)
  %41 = add i64 %40, 1
  br label %42

42:                                               ; preds = %38, %35
  %43 = phi i64 [ 0, %35 ], [ %41, %38 ]
  %44 = getelementptr inbounds nuw i8, ptr %28, i64 8
  store i64 %43, ptr %44, align 8
  %45 = add i64 %43, 1
  %46 = getelementptr inbounds nuw i8, ptr %28, i64 16
  store i64 %45, ptr %46, align 8
  %47 = tail call noalias align 32 dereferenceable_or_null(1) ptr @pony_alloc(ptr %4, i64 %45)
  %48 = getelementptr inbounds nuw i8, ptr %28, i64 24
  store ptr %47, ptr %48, align 8
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 32 %47, ptr nonnull readonly align 1 %27, i64 %45, i1 false)
  br label %49

49:                                               ; preds = %30, %42
  %50 = add i64 %23, 1
  %51 = load i64, ptr %17, align 8
  %52 = icmp ult i64 %51, %50
  br i1 %52, label %53, label %64

53:                                               ; preds = %49
  %54 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %23, i1 false)
  %55 = icmp eq i64 %54, 0
  %56 = sub nuw nsw i64 64, %54
  %57 = shl nuw i64 1, %56
  %58 = tail call i64 @llvm.umax.i64(i64 %57, i64 %50)
  %59 = select i1 %55, i64 %50, i64 %58
  %60 = tail call i64 @llvm.umax.i64(i64 %59, i64 8)
  store i64 %60, ptr %17, align 8
  %61 = shl i64 %60, 3
  %62 = shl i64 %23, 3
  %63 = tail call noalias align 32 dereferenceable_or_null(8) ptr @pony_realloc(ptr %4, ptr %22, i64 %61, i64 %62)
  br label %64

64:                                               ; preds = %49, %53
  %65 = phi ptr [ %63, %53 ], [ %22, %49 ]
  %66 = getelementptr inbounds ptr, ptr %65, i64 %23
  store ptr %28, ptr %66, align 8
  %67 = icmp eq i64 %25, %2
  br i1 %67, label %70, label %21

68:                                               ; preds = %3
  %69 = getelementptr inbounds nuw i8, ptr %5, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %69, i8 0, i64 16, i1 false)
  br label %71

70:                                               ; preds = %64
  store i64 %50, ptr %6, align 8
  store ptr %65, ptr %20, align 8
  br label %71

71:                                               ; preds = %70, %68
  ret ptr %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc ptr @65(ptr readnone returned captures(ret: address, provenance) %0) unnamed_addr #7 !pony.abi !2 {
  ret ptr %0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc i1 @66(ptr readnone captures(none) %0, i32 %1) unnamed_addr #7 !pony.abi !2 {
  %3 = and i32 %1, 1
  %4 = icmp ne i32 %3, 0
  ret i1 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc i1 @67(ptr readnone captures(none) %0, i32 %1) unnamed_addr #7 !pony.abi !2 {
  %3 = and i32 %1, 1
  %4 = icmp ne i32 %3, 0
  ret i1 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc i1 @68(ptr readnone captures(none) %0, i32 %1) unnamed_addr #7 !pony.abi !2 {
  %3 = and i32 %1, 16
  %4 = icmp ne i32 %3, 0
  ret i1 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc i1 @69(ptr readnone captures(none) %0, i32 %1) unnamed_addr #7 !pony.abi !2 {
  %3 = and i32 %1, 16
  %4 = icmp ne i32 %3, 0
  ret i1 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc i1 @70(ptr readnone captures(none) %0, i32 %1) unnamed_addr #7 !pony.abi !2 {
  %3 = icmp eq i32 %1, 0
  ret i1 %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc i1 @71(ptr readnone captures(none) %0, i32 %1) unnamed_addr #7 !pony.abi !2 {
  %3 = icmp eq i32 %1, 0
  ret i1 %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc noalias noundef ptr @72(ptr readnone captures(none) %0) unnamed_addr #7 !pony.abi !2 {
  ret ptr null
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc noalias noundef ptr @73(ptr readnone captures(none) %0) unnamed_addr #7 !pony.abi !2 {
  ret ptr null
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc ptr @74(ptr readnone returned captures(ret: address, provenance) %0) unnamed_addr #7 !pony.abi !2 {
  ret ptr %0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc range(i64 0, 256) i64 @75(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i8, ptr %2, align 1
  %4 = zext i8 %3 to i64
  ret i64 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc noalias noundef ptr @76(ptr readnone captures(none) %0) unnamed_addr #7 !pony.abi !2 {
  ret ptr null
}

; Function Attrs: nounwind
define private fastcc noalias align 32 dereferenceable_or_null(1) ptr @77(ptr readnone captures(none) %0, i64 %1) unnamed_addr #2 !pony.abi !2 {
  %3 = tail call ptr @pony_ctx()
  %4 = tail call ptr @pony_alloc(ptr %3, i64 %1)
  ret ptr %4
}

; Function Attrs: nounwind
define private fastcc noalias align 32 dereferenceable_or_null(1) ptr @78(ptr %0, i64 %1, i64 %2) unnamed_addr #2 !pony.abi !2 {
  %4 = tail call ptr @pony_ctx()
  %5 = tail call ptr @pony_realloc(ptr %4, ptr %0, i64 %1, i64 %2)
  ret ptr %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i8 @79(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds i8, ptr %0, i64 %1
  %4 = load i8, ptr %3, align 1
  ret i8 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i8 @80(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds i8, ptr %0, i64 %1
  %4 = load i8, ptr %3, align 1
  ret i8 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i8 @81(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds i8, ptr %0, i64 %1
  %4 = load i8, ptr %3, align 1
  ret i8 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define private fastcc i8 @82(ptr captures(none) %0, i64 %1, i8 %2) unnamed_addr #10 !pony.abi !2 {
  %4 = getelementptr inbounds i8, ptr %0, i64 %1
  %5 = load i8, ptr %4, align 1
  store i8 %2, ptr %4, align 1
  ret i8 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc ptr @83(ptr readnone captures(ret: address, provenance) %0, i64 %1) unnamed_addr #7 !pony.abi !2 {
  %3 = getelementptr inbounds i8, ptr %0, i64 %1
  ret ptr %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc ptr @84(ptr readnone captures(ret: address, provenance) %0, i64 %1) unnamed_addr #7 !pony.abi !2 {
  %3 = getelementptr inbounds i8, ptr %0, i64 %1
  ret ptr %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc ptr @85(ptr readnone captures(ret: address, provenance) %0, i64 %1) unnamed_addr #7 !pony.abi !2 {
  %3 = getelementptr inbounds i8, ptr %0, i64 %1
  ret ptr %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define private fastcc ptr @86(ptr readonly returned captures(ret: address, provenance) %0, ptr writeonly captures(none) %1, i64 %2) unnamed_addr #10 !pony.abi !2 {
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %1, ptr align 1 %0, i64 %2, i1 false)
  ret ptr %0
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #12

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define private fastcc ptr @87(ptr readonly returned captures(ret: address, provenance) %0, ptr writeonly captures(none) %1, i64 %2) unnamed_addr #10 !pony.abi !2 {
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %1, ptr align 1 %0, i64 %2, i1 false)
  ret ptr %0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define private fastcc ptr @88(ptr readonly returned captures(ret: address, provenance) %0, ptr writeonly captures(none) %1, i64 %2) unnamed_addr #10 !pony.abi !2 {
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %1, ptr align 1 %0, i64 %2, i1 false)
  ret ptr %0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc i1 @89(ptr readnone captures(address_is_null) %0) unnamed_addr #7 !pony.abi !2 {
  %2 = icmp eq ptr %0, null
  ret i1 %2
}

declare ptr @pony_os_stderr() local_unnamed_addr

declare ptr @pony_os_stdout() local_unnamed_addr

declare i64 @pony_os_stdin_read(ptr, i64) local_unnamed_addr

declare void @pony_asio_event_unsubscribe(ptr) local_unnamed_addr

declare void @pony_asio_event_destroy(ptr) local_unnamed_addr

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.ctlz.i64(i64, i1 immarg) #13

declare void @pony_os_stdout_setup() local_unnamed_addr

declare i1 @pony_os_stdin_setup() local_unnamed_addr

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @U32_Serialise(ptr readnone captures(none) %0, ptr readonly captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #10 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 1139018605533389629, ptr %6, align 8
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %8 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %9 = load i32, ptr %7, align 4
  store i32 %9, ptr %8, align 4
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define dso_local void @U32_Deserialise(ptr readnone captures(none) %0, ptr writeonly captures(none) initializes((0, 8)) %1) unnamed_addr #14 !pony.abi !2 {
  store ptr @0, ptr %1, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i32 @90(ptr readonly captures(none) %0, i32 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i32, ptr %3, align 4
  %5 = and i32 %4, %1
  ret i32 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i32 @91(ptr readonly captures(none) %0, i32 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i32, ptr %3, align 4
  %5 = and i32 %4, %1
  ret i32 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i32 @92(ptr readonly captures(none) %0, i32 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i32, ptr %3, align 4
  %5 = tail call i32 @llvm.umin.i32(i32 %1, i32 31)
  %6 = shl i32 %4, %5
  ret i32 %6
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i32 @93(ptr readonly captures(none) %0, i32 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i32, ptr %3, align 4
  %5 = tail call i32 @llvm.umin.i32(i32 %1, i32 31)
  %6 = shl i32 %4, %5
  ret i32 %6
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc range(i64 0, 4294967296) i64 @94(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i32, ptr %2, align 4
  %4 = zext i32 %3 to i64
  ret i64 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc range(i64 0, 4294967296) i64 @95(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i32, ptr %2, align 4
  %4 = zext i32 %3 to i64
  ret i64 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @96(ptr readonly captures(none) %0, i32 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i32, ptr %3, align 4
  %5 = icmp ne i32 %4, %1
  ret i1 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @97(ptr readonly captures(none) %0, i32 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i32, ptr %3, align 4
  %5 = icmp ne i32 %4, %1
  ret i1 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @98(ptr readonly captures(none) %0, i32 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i32, ptr %3, align 4
  %5 = icmp eq i32 %4, %1
  ret i1 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @99(ptr readonly captures(none) %0, i32 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i32, ptr %3, align 4
  %5 = icmp eq i32 %4, %1
  ret i1 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc i32 @100(ptr readnone captures(none) %0, i32 %1, i32 returned %2) unnamed_addr #7 !pony.abi !2 {
  ret i32 %2
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define dso_local void @"$0$16_Serialise"(ptr readnone captures(none) %0, ptr readnone captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #14 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 4121416555796745523, ptr %6, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define dso_local void @AmbientAuth_Serialise(ptr readnone captures(none) %0, ptr readnone captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #14 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 224156590155586631, ptr %6, align 8
  ret void
}

; Function Attrs: nounwind
define dso_local void @String_SerialiseTrace(ptr %0, ptr readonly captures(none) %1, ptr readnone captures(none) %2, i64 %3, i32 %4) unnamed_addr #2 !pony.abi !2 {
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %7 = load i64, ptr %6, align 8
  %8 = add i64 %7, 1
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %10 = load ptr, ptr %9, align 8
  tail call void @pony_serialise_reserve(ptr %0, ptr %10, i64 %8)
  ret void
}

; Function Attrs: nounwind
define dso_local void @String_Serialise(ptr %0, ptr readonly captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #2 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 5851970689856509530, ptr %6, align 8
  %7 = icmp eq i32 %4, 2
  br i1 %7, label %20, label %8

8:                                                ; preds = %5
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %10 = load i64, ptr %9, align 8
  %11 = getelementptr inbounds nuw i8, ptr %6, i64 8
  store i64 %10, ptr %11, align 8
  %12 = add i64 %10, 1
  %13 = getelementptr inbounds nuw i8, ptr %6, i64 16
  store i64 %12, ptr %13, align 8
  %14 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %15 = load ptr, ptr %14, align 8
  %16 = tail call i64 @pony_serialise_offset(ptr %0, ptr %15)
  %17 = getelementptr inbounds nuw i8, ptr %6, i64 24
  store i64 %16, ptr %17, align 8
  %18 = getelementptr inbounds i8, ptr %2, i64 %16
  %19 = load ptr, ptr %14, align 8
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %18, ptr align 1 %19, i64 %12, i1 false)
  br label %20

20:                                               ; preds = %8, %5
  ret void
}

; Function Attrs: memory(argmem: readwrite, inaccessiblemem: readwrite)
define dso_local void @String_Deserialise(ptr %0, ptr captures(none) initializes((0, 8)) %1) unnamed_addr #3 !pony.abi !2 {
  store ptr @6, ptr %1, align 8
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %4 = load i64, ptr %3, align 8
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %6 = load ptr, ptr %5, align 8
  %7 = ptrtoint ptr %6 to i64
  %8 = tail call ptr @pony_deserialise_block(ptr %0, i64 %7, i64 %4)
  store ptr %8, ptr %5, align 8
  ret void
}

; Function Attrs: nounwind
define dso_local void @Array_String_val_SerialiseTrace(ptr %0, ptr readonly captures(none) %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %12, label %6

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %8 = load ptr, ptr %7, align 8
  %9 = shl i64 %4, 3
  tail call void @pony_serialise_reserve(ptr %0, ptr %8, i64 %9)
  %10 = load i64, ptr %3, align 8
  %11 = icmp eq i64 %10, 0
  br i1 %11, label %12, label %13

12:                                               ; preds = %13, %6, %2
  ret void

13:                                               ; preds = %6, %13
  %14 = phi i64 [ %17, %13 ], [ 0, %6 ]
  %15 = getelementptr inbounds ptr, ptr %8, i64 %14
  %16 = load ptr, ptr %15, align 8
  tail call void @pony_traceknown(ptr %0, ptr %16, ptr nonnull @6, i32 1)
  %17 = add nuw i64 %14, 1
  %18 = icmp eq i64 %17, %10
  br i1 %18, label %12, label %13
}

; Function Attrs: nounwind
define dso_local void @Array_String_val_Serialise(ptr %0, ptr readonly captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #2 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 8135060660710234859, ptr %6, align 8
  %7 = icmp eq i32 %4, 2
  br i1 %7, label %29, label %8

8:                                                ; preds = %5
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %10 = load i64, ptr %9, align 8
  %11 = getelementptr inbounds nuw i8, ptr %6, i64 8
  store i64 %10, ptr %11, align 8
  %12 = getelementptr inbounds nuw i8, ptr %6, i64 16
  store i64 %10, ptr %12, align 8
  %13 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %14 = load ptr, ptr %13, align 8
  %15 = tail call i64 @pony_serialise_offset(ptr %0, ptr %14)
  %16 = getelementptr inbounds nuw i8, ptr %6, i64 24
  store i64 %15, ptr %16, align 8
  %17 = icmp eq i64 %10, 0
  br i1 %17, label %29, label %18

18:                                               ; preds = %8
  %19 = getelementptr inbounds i8, ptr %2, i64 %15
  br label %20

20:                                               ; preds = %18, %20
  %21 = phi i64 [ %27, %20 ], [ 0, %18 ]
  %22 = phi ptr [ %26, %20 ], [ %19, %18 ]
  %23 = getelementptr inbounds ptr, ptr %14, i64 %21
  %24 = load ptr, ptr %23, align 8
  %25 = tail call i64 @pony_serialise_offset(ptr %0, ptr %24)
  store i64 %25, ptr %22, align 8
  %26 = getelementptr inbounds nuw i8, ptr %22, i64 8
  %27 = add nuw i64 %21, 1
  %28 = icmp eq i64 %27, %10
  br i1 %28, label %29, label %20

29:                                               ; preds = %20, %8, %5
  ret void
}

define dso_local void @Array_String_val_Deserialise(ptr %0, ptr captures(none) initializes((0, 8)) %1) unnamed_addr !pony.abi !2 {
  store ptr @7, ptr %1, align 8
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %4 = load i64, ptr %3, align 8
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %6 = load ptr, ptr %5, align 8
  %7 = ptrtoint ptr %6 to i64
  %8 = shl i64 %4, 3
  %9 = tail call ptr @pony_deserialise_block(ptr %0, i64 %7, i64 %8)
  store ptr %9, ptr %5, align 8
  %10 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %11 = load i64, ptr %10, align 8
  %12 = icmp eq i64 %11, 0
  br i1 %12, label %20, label %13

13:                                               ; preds = %2, %13
  %14 = phi i64 [ %18, %13 ], [ 0, %2 ]
  %15 = getelementptr inbounds ptr, ptr %9, i64 %14
  %16 = load i64, ptr %15, align 8
  %17 = tail call ptr @pony_deserialise_offset(ptr %0, ptr nonnull @6, i64 %16)
  store ptr %17, ptr %15, align 8
  %18 = add nuw i64 %14, 1
  %19 = icmp eq i64 %18, %11
  br i1 %19, label %20, label %13

20:                                               ; preds = %13, %2
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @Bool_Serialise(ptr readnone captures(none) %0, ptr readonly captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #10 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 399969149820176696, ptr %6, align 8
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %8 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %9 = load i8, ptr %7, align 1
  store i8 %9, ptr %8, align 1
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define dso_local void @Bool_Deserialise(ptr readnone captures(none) %0, ptr writeonly captures(none) initializes((0, 8)) %1) unnamed_addr #14 !pony.abi !2 {
  store ptr @8, ptr %1, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @101(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i1, ptr %2, align 1
  %4 = xor i1 %3, true
  ret i1 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @102(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i1, ptr %2, align 1
  %4 = xor i1 %3, true
  ret i1 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc i1 @103(ptr readnone captures(none) %0, i1 %1, i1 returned %2) unnamed_addr #7 !pony.abi !2 {
  ret i1 %2
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @104(ptr readonly captures(none) %0, i1 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i1, ptr %3, align 1
  %5 = select i1 %4, i1 %1, i1 false
  ret i1 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @105(ptr readonly captures(none) %0, i1 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i1, ptr %3, align 1
  %5 = select i1 %4, i1 %1, i1 false
  ret i1 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @F64_Serialise(ptr readnone captures(none) %0, ptr readonly captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #10 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 6356976178404583306, ptr %6, align 8
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %8 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %9 = load double, ptr %7, align 8
  store double %9, ptr %8, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define dso_local void @F64_Deserialise(ptr readnone captures(none) %0, ptr writeonly captures(none) initializes((0, 8)) %1) unnamed_addr #14 !pony.abi !2 {
  store ptr @9, ptr %1, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @U64_Serialise(ptr readnone captures(none) %0, ptr readonly captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #10 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 771316481207920882, ptr %6, align 8
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %8 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %9 = load i64, ptr %7, align 8
  store i64 %9, ptr %8, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define dso_local void @U64_Deserialise(ptr readnone captures(none) %0, ptr writeonly captures(none) initializes((0, 8)) %1) unnamed_addr #14 !pony.abi !2 {
  store ptr @11, ptr %1, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @106(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  ret i64 %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @107(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  ret i64 %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @USize_Serialise(ptr readnone captures(none) %0, ptr readonly captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #10 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 771016527523638713, ptr %6, align 8
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %8 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %9 = load i64, ptr %7, align 8
  store i64 %9, ptr %8, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define dso_local void @USize_Deserialise(ptr readnone captures(none) %0, ptr writeonly captures(none) initializes((0, 8)) %1) unnamed_addr #14 !pony.abi !2 {
  store ptr @12, ptr %1, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @108(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  ret i64 %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @109(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  ret i64 %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc noundef i64 @110(ptr readonly captures(none) %0) unnamed_addr #7 !pony.abi !2 {
  ret i64 64
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc noundef i64 @111(ptr readonly captures(none) %0) unnamed_addr #7 !pony.abi !2 {
  ret i64 64
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @112(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = sub i64 %4, %1
  ret i64 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @113(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = sub i64 %4, %1
  ret i64 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @114(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = tail call i64 @llvm.umin.i64(i64 %1, i64 63)
  %6 = shl i64 %4, %5
  ret i64 %6
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @115(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = tail call i64 @llvm.umin.i64(i64 %1, i64 63)
  %6 = shl i64 %4, %5
  ret i64 %6
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @116(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = add i64 %4, %1
  ret i64 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @117(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = add i64 %4, %1
  ret i64 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc range(i64 1, -9223372036854775807) i64 @118(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  %4 = add i64 %3, -1
  %5 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %4, i1 false)
  %6 = icmp eq i64 %5, 0
  %7 = sub nuw nsw i64 64, %5
  %8 = shl nuw i64 1, %7
  %9 = select i1 %6, i64 1, i64 %8
  ret i64 %9
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc range(i64 1, -9223372036854775807) i64 @119(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  %4 = add i64 %3, -1
  %5 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %4, i1 false)
  %6 = icmp eq i64 %5, 0
  %7 = sub nuw nsw i64 64, %5
  %8 = shl nuw i64 1, %7
  %9 = select i1 %6, i64 1, i64 %8
  ret i64 %9
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @120(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = icmp eq i64 %4, %1
  ret i1 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @121(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = icmp eq i64 %4, %1
  ret i1 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc range(i64 0, 65) i64 @122(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  %4 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %3, i1 false)
  ret i64 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc range(i64 0, 65) i64 @123(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  %4 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %3, i1 false)
  ret i64 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @124(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = tail call i64 @llvm.umax.i64(i64 %4, i64 %1)
  ret i64 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @125(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = tail call i64 @llvm.umax.i64(i64 %4, i64 %1)
  ret i64 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @126(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  %4 = sub i64 0, %3
  ret i64 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @127(ptr readonly captures(none) %0) unnamed_addr #8 !pony.abi !2 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i64, ptr %2, align 8
  %4 = sub i64 0, %3
  ret i64 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @128(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = tail call i64 @llvm.umin.i64(i64 %4, i64 %1)
  ret i64 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i64 @129(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = tail call i64 @llvm.umin.i64(i64 %4, i64 %1)
  ret i64 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc i64 @130(ptr readnone captures(none) %0, i64 %1, i64 returned %2) unnamed_addr #7 !pony.abi !2 {
  ret i64 %2
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @131(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = icmp ult i64 %4, %1
  ret i1 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @132(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = icmp ult i64 %4, %1
  ret i1 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @133(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = icmp ugt i64 %4, %1
  ret i1 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @134(ptr readonly captures(none) %0, i64 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = icmp ugt i64 %4, %1
  ret i1 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @RuntimeOptions_Serialise(ptr readnone captures(none) %0, ptr readonly captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #10 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  %7 = load i32, ptr %1, align 4
  store i32 %7, ptr %6, align 4
  %8 = getelementptr inbounds nuw i8, ptr %1, i64 4
  %9 = getelementptr inbounds nuw i8, ptr %6, i64 4
  %10 = load i32, ptr %8, align 4
  store i32 %10, ptr %9, align 4
  %11 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %12 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %13 = load i8, ptr %11, align 1
  store i8 %13, ptr %12, align 1
  %14 = getelementptr inbounds nuw i8, ptr %1, i64 12
  %15 = getelementptr inbounds nuw i8, ptr %6, i64 12
  %16 = load i32, ptr %14, align 4
  store i32 %16, ptr %15, align 4
  %17 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %18 = getelementptr inbounds nuw i8, ptr %6, i64 16
  %19 = load i32, ptr %17, align 4
  store i32 %19, ptr %18, align 4
  %20 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %21 = getelementptr inbounds nuw i8, ptr %6, i64 24
  %22 = load i64, ptr %20, align 8
  store i64 %22, ptr %21, align 8
  %23 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %24 = getelementptr inbounds nuw i8, ptr %6, i64 32
  %25 = load double, ptr %23, align 8
  store double %25, ptr %24, align 8
  %26 = getelementptr inbounds nuw i8, ptr %1, i64 40
  %27 = getelementptr inbounds nuw i8, ptr %6, i64 40
  %28 = load i8, ptr %26, align 1
  store i8 %28, ptr %27, align 1
  %29 = getelementptr inbounds nuw i8, ptr %1, i64 41
  %30 = getelementptr inbounds nuw i8, ptr %6, i64 41
  %31 = load i8, ptr %29, align 1
  store i8 %31, ptr %30, align 1
  %32 = getelementptr inbounds nuw i8, ptr %1, i64 42
  %33 = getelementptr inbounds nuw i8, ptr %6, i64 42
  %34 = load i8, ptr %32, align 1
  store i8 %34, ptr %33, align 1
  %35 = getelementptr inbounds nuw i8, ptr %1, i64 43
  %36 = getelementptr inbounds nuw i8, ptr %6, i64 43
  %37 = load i8, ptr %35, align 1
  store i8 %37, ptr %36, align 1
  %38 = getelementptr inbounds nuw i8, ptr %1, i64 44
  %39 = getelementptr inbounds nuw i8, ptr %6, i64 44
  %40 = load i8, ptr %38, align 1
  store i8 %40, ptr %39, align 1
  %41 = getelementptr inbounds nuw i8, ptr %1, i64 48
  %42 = getelementptr inbounds nuw i8, ptr %6, i64 48
  %43 = load i32, ptr %41, align 4
  store i32 %43, ptr %42, align 4
  %44 = getelementptr inbounds nuw i8, ptr %1, i64 52
  %45 = getelementptr inbounds nuw i8, ptr %6, i64 52
  %46 = load i8, ptr %44, align 1
  store i8 %46, ptr %45, align 1
  %47 = getelementptr inbounds nuw i8, ptr %1, i64 53
  %48 = getelementptr inbounds nuw i8, ptr %6, i64 53
  %49 = load i8, ptr %47, align 1
  store i8 %49, ptr %48, align 1
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local void @RuntimeOptions_Deserialise(ptr readnone captures(none) %0, ptr readnone captures(none) %1) unnamed_addr #7 !pony.abi !2 {
  ret void
}

; Function Attrs: nounwind
define dso_local void @Array_U8_val_SerialiseTrace(ptr %0, ptr readonly captures(none) %1) unnamed_addr #2 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %9, label %6

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %8 = load ptr, ptr %7, align 8
  tail call void @pony_serialise_reserve(ptr %0, ptr %8, i64 %4)
  br label %9

9:                                                ; preds = %6, %2
  ret void
}

; Function Attrs: nounwind
define dso_local void @Array_U8_val_Serialise(ptr %0, ptr readonly captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #2 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 5654314923058204166, ptr %6, align 8
  %7 = icmp eq i32 %4, 2
  br i1 %7, label %18, label %8

8:                                                ; preds = %5
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %10 = load i64, ptr %9, align 8
  %11 = getelementptr inbounds nuw i8, ptr %6, i64 8
  store i64 %10, ptr %11, align 8
  %12 = getelementptr inbounds nuw i8, ptr %6, i64 16
  store i64 %10, ptr %12, align 8
  %13 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %14 = load ptr, ptr %13, align 8
  %15 = tail call i64 @pony_serialise_offset(ptr %0, ptr %14)
  %16 = getelementptr inbounds nuw i8, ptr %6, i64 24
  store i64 %15, ptr %16, align 8
  %17 = getelementptr inbounds i8, ptr %2, i64 %15
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %17, ptr align 1 %14, i64 %10, i1 false)
  br label %18

18:                                               ; preds = %8, %5
  ret void
}

; Function Attrs: memory(argmem: readwrite, inaccessiblemem: readwrite)
define dso_local void @Array_U8_val_Deserialise(ptr %0, ptr captures(none) initializes((0, 8)) %1) unnamed_addr #3 !pony.abi !2 {
  store ptr @13, ptr %1, align 8
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %4 = load i64, ptr %3, align 8
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %6 = load ptr, ptr %5, align 8
  %7 = ptrtoint ptr %6 to i64
  %8 = tail call ptr @pony_deserialise_block(ptr %0, i64 %7, i64 %4)
  store ptr %8, ptr %5, align 8
  ret void
}

; Function Attrs: nounwind
define dso_local void @Env_Serialise(ptr %0, ptr readonly captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #2 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 38155807658830253, ptr %6, align 8
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %8 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %9 = load ptr, ptr %7, align 8
  %10 = tail call i64 @pony_serialise_offset(ptr %0, ptr %9)
  store i64 %10, ptr %8, align 8
  %11 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %12 = getelementptr inbounds nuw i8, ptr %6, i64 16
  %13 = load ptr, ptr %11, align 8
  %14 = tail call i64 @pony_serialise_offset(ptr %0, ptr %13)
  store i64 %14, ptr %12, align 8
  %15 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %16 = getelementptr inbounds nuw i8, ptr %6, i64 24
  %17 = load ptr, ptr %15, align 8
  %18 = tail call i64 @pony_serialise_offset(ptr %0, ptr %17)
  store i64 %18, ptr %16, align 8
  %19 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %20 = getelementptr inbounds nuw i8, ptr %6, i64 32
  %21 = load ptr, ptr %19, align 8
  %22 = tail call i64 @pony_serialise_offset(ptr %0, ptr %21)
  store i64 %22, ptr %20, align 8
  %23 = getelementptr inbounds nuw i8, ptr %1, i64 40
  %24 = getelementptr inbounds nuw i8, ptr %6, i64 40
  %25 = load ptr, ptr %23, align 8
  %26 = tail call i64 @pony_serialise_offset(ptr %0, ptr %25)
  store i64 %26, ptr %24, align 8
  %27 = getelementptr inbounds nuw i8, ptr %1, i64 48
  %28 = getelementptr inbounds nuw i8, ptr %6, i64 48
  %29 = load ptr, ptr %27, align 8
  %30 = tail call i64 @pony_serialise_offset(ptr %0, ptr %29)
  store i64 %30, ptr %28, align 8
  %31 = getelementptr inbounds nuw i8, ptr %1, i64 56
  %32 = getelementptr inbounds nuw i8, ptr %6, i64 56
  %33 = load ptr, ptr %31, align 8
  %34 = tail call i64 @pony_serialise_offset(ptr %0, ptr %33)
  store i64 %34, ptr %32, align 8
  ret void
}

define dso_local void @Env_Deserialise(ptr %0, ptr captures(none) initializes((0, 8)) %1) unnamed_addr !pony.abi !2 {
  store ptr @14, ptr %1, align 8
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %4 = load i64, ptr %3, align 8
  %5 = tail call ptr @pony_deserialise_offset(ptr %0, ptr nonnull @3, i64 %4)
  store ptr %5, ptr %3, align 8
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %7 = load i64, ptr %6, align 8
  %8 = tail call ptr @pony_deserialise_offset(ptr %0, ptr null, i64 %7)
  store ptr %8, ptr %6, align 8
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %10 = load i64, ptr %9, align 8
  %11 = tail call ptr @pony_deserialise_offset(ptr %0, ptr null, i64 %10)
  store ptr %11, ptr %9, align 8
  %12 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %13 = load i64, ptr %12, align 8
  %14 = tail call ptr @pony_deserialise_offset(ptr %0, ptr null, i64 %13)
  store ptr %14, ptr %12, align 8
  %15 = getelementptr inbounds nuw i8, ptr %1, i64 40
  %16 = load i64, ptr %15, align 8
  %17 = tail call ptr @pony_deserialise_offset(ptr %0, ptr nonnull @7, i64 %16)
  store ptr %17, ptr %15, align 8
  %18 = getelementptr inbounds nuw i8, ptr %1, i64 48
  %19 = load i64, ptr %18, align 8
  %20 = tail call ptr @pony_deserialise_offset(ptr %0, ptr nonnull @7, i64 %19)
  store ptr %20, ptr %18, align 8
  %21 = getelementptr inbounds nuw i8, ptr %1, i64 56
  %22 = load i64, ptr %21, align 8
  %23 = tail call ptr @pony_deserialise_offset(ptr %0, ptr null, i64 %22)
  store ptr %23, ptr %21, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define dso_local void @None_Serialise(ptr readnone captures(none) %0, ptr readnone captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #14 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 6637518656916771930, ptr %6, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define dso_local void @AsioEvent_Serialise(ptr readnone captures(none) %0, ptr readnone captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #14 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 412291322119311248, ptr %6, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @U8_Serialise(ptr readnone captures(none) %0, ptr readonly captures(none) %1, ptr writeonly captures(none) %2, i64 %3, i32 %4) unnamed_addr #10 !pony.abi !2 {
  %6 = getelementptr inbounds i8, ptr %2, i64 %3
  store i64 537680212197767059, ptr %6, align 8
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %8 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %9 = load i8, ptr %7, align 1
  store i8 %9, ptr %8, align 1
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define dso_local void @U8_Deserialise(ptr readnone captures(none) %0, ptr writeonly captures(none) initializes((0, 8)) %1) unnamed_addr #14 !pony.abi !2 {
  store ptr @17, ptr %1, align 8
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define private fastcc i8 @135(ptr readnone captures(none) %0, i8 %1, i8 returned %2) unnamed_addr #7 !pony.abi !2 {
  ret i8 %2
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @136(ptr readonly captures(none) %0, i8 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i8, ptr %3, align 1
  %5 = icmp ne i8 %4, %1
  ret i1 %5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define private fastcc i1 @137(ptr readonly captures(none) %0, i8 %1) unnamed_addr #8 !pony.abi !2 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i8, ptr %3, align 1
  %5 = icmp ne i8 %4, %1
  ret i1 %5
}

define i32 @main(i32 %0, ptr %1, ptr readonly captures(address_is_null) %2) local_unnamed_addr {
  %4 = alloca { i8, i8, ptr, i64, ptr }, align 8
  %5 = tail call i32 @pony_init(i32 %0, ptr %1)
  %6 = tail call ptr @pony_ctx()
  %7 = tail call ptr @pony_create(ptr %6, ptr nonnull @5, i1 false)
  tail call void @ponyint_become(ptr %6, ptr nonnull %7)
  %8 = tail call ptr @pony_alloc_small(ptr %6, i32 1)
  store ptr @14, ptr %8, align 8
  tail call fastcc void @62(ptr nonnull %8, i32 %5, ptr %1, ptr %2)
  %9 = tail call ptr @pony_alloc_msg(i32 0, i32 1)
  %10 = getelementptr inbounds nuw i8, ptr %9, i64 16
  store ptr %8, ptr %10, align 8
  tail call void @pony_gc_send(ptr %6)
  tail call void @pony_traceknown(ptr %6, ptr nonnull %8, ptr nonnull @14, i32 1)
  tail call void @pony_send_done(ptr %6)
  tail call void @pony_sendv_single(ptr %6, ptr nonnull %7, ptr %9, ptr %9, i1 true)
  tail call void @ponyint_become(ptr %6, ptr null)
  store i8 1, ptr %4, align 8
  %11 = getelementptr inbounds nuw i8, ptr %4, i64 1
  store i8 1, ptr %11, align 1
  %12 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store ptr @19, ptr %12, align 8
  %13 = getelementptr inbounds nuw i8, ptr %4, i64 16
  store i64 24, ptr %13, align 8
  %14 = getelementptr inbounds nuw i8, ptr %4, i64 24
  store ptr @__DescOffsetLookupFn, ptr %14, align 8
  %15 = call i1 @pony_start(i1 false, ptr null, ptr nonnull %4)
  br i1 %15, label %18, label %16

16:                                               ; preds = %3
  %17 = call i32 @puts(ptr nonnull dereferenceable(1) @29)
  br label %18

18:                                               ; preds = %16, %3
  call void @ponyint_become(ptr %6, ptr null)
  %19 = call i32 @pony_get_exitcode()
  %20 = select i1 %15, i32 %19, i32 -1
  ret i32 %20
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #15

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umin.i64(i64, i64) #15

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #15

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: read)
declare i64 @strlen(ptr captures(none)) local_unnamed_addr #16

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #17

attributes #0 = { nofree nosync nounwind memory(none) }
attributes #1 = { nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #2 = { nounwind }
attributes #3 = { memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #4 = { nofree nounwind memory(argmem: read) }
attributes #5 = { noreturn }
attributes #6 = { nofree nounwind }
attributes #7 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
attributes #8 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read) }
attributes #9 = { mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, inaccessiblemem: none) }
attributes #10 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite) }
attributes #11 = { nofree norecurse nosync nounwind memory(argmem: read) }
attributes #12 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #13 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #14 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) }
attributes #15 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #16 = { nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #17 = { nocallback nofree nounwind willreturn memory(argmem: write) }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
!2 = !{}
