" hints_man3.vim
"   Author: Charles E. Campbell, Jr.
"   Date:   Mar 13, 2007
"   Version: 1
" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("b:loaded_hints_man3")
 finish
endif
let b:loaded_hints_man3= "v1"
let s:keepcpo          = &cpo
set cpo&vim

" ---------------------------------------------------------------------
" Hints! {{{1
inorea a64l	a64l<c-o>:echoh HintHL<Bar>echo "long a64l(char * str64)"<Bar>echoh None<cr>
inorea abort	abort<c-o>:echoh HintHL<Bar>echo "void abort(void)"<Bar>echoh None<cr>
inorea abs	abs<c-o>:echoh HintHL<Bar>echo "int abs(int j)"<Bar>echoh None<cr>
inorea acos	acos<c-o>:echoh HintHL<Bar>echo "double acos(double x)"<Bar>echoh None<cr>
inorea acosf	acosf<c-o>:echoh HintHL<Bar>echo "float acosf(float x)"<Bar>echoh None<cr>
inorea acosh	acosh<c-o>:echoh HintHL<Bar>echo "double acosh(double x)"<Bar>echoh None<cr>
inorea acoshf	acoshf<c-o>:echoh HintHL<Bar>echo "float acoshf(float x)"<Bar>echoh None<cr>
inorea acoshl	acoshl<c-o>:echoh HintHL<Bar>echo "long double acoshl(long double x)"<Bar>echoh None<cr>
inorea acosl	acosl<c-o>:echoh HintHL<Bar>echo "long double acosl(long double x)"<Bar>echoh None<cr>
inorea addch	addch<c-o>:echoh HintHL<Bar>echo "int addch(const chtype ch)"<Bar>echoh None<cr>
inorea addchnstr	addchnstr<c-o>:echoh HintHL<Bar>echo "int addchnstr(const chtype *chstr, int n)"<Bar>echoh None<cr>
inorea addchstr	addchstr<c-o>:echoh HintHL<Bar>echo "int addchstr(const chtype *chstr)"<Bar>echoh None<cr>
inorea addmntent	addmntent<c-o>:echoh HintHL<Bar>echo "int addmntent(FILE * fp, const struct mntent * mnt)"<Bar>echoh None<cr>
inorea addnstr	addnstr<c-o>:echoh HintHL<Bar>echo "int addnstr(const char *str, int n)"<Bar>echoh None<cr>
inorea addnwstr	addnwstr<c-o>:echoh HintHL<Bar>echo "int addnwstr(const wchar_t *wstr, int n)"<Bar>echoh None<cr>
inorea addseverity	addseverity<c-o>:echoh HintHL<Bar>echo "int addseverity(int severity, const char * s)"<Bar>echoh None<cr>
inorea addstr	addstr<c-o>:echoh HintHL<Bar>echo "int addstr(const char *str)"<Bar>echoh None<cr>
inorea add_wch	add_wch<c-o>:echoh HintHL<Bar>echo "int add_wch( const cchar_t *wch)"<Bar>echoh None<cr>
inorea add_wchnstr	add_wchnstr<c-o>:echoh HintHL<Bar>echo "int add_wchnstr(const cchar_t *wchstr, int n)"<Bar>echoh None<cr>
inorea add_wchstr	add_wchstr<c-o>:echoh HintHL<Bar>echo "int add_wchstr(const cchar_t *wchstr)"<Bar>echoh None<cr>
inorea addwstr	addwstr<c-o>:echoh HintHL<Bar>echo "int addwstr(const wchar_t *wstr)"<Bar>echoh None<cr>
inorea aio_cancel	aio_cancel<c-o>:echoh HintHL<Bar>echo "int aio_cancel(int fd, struct aiocb * aiocbp)"<Bar>echoh None<cr>
inorea aio_error	aio_error<c-o>:echoh HintHL<Bar>echo "int aio_error(const struct aiocb * aiocbp)"<Bar>echoh None<cr>
inorea aio_fsync	aio_fsync<c-o>:echoh HintHL<Bar>echo "int aio_fsync(int op, struct aiocb * aiocbp)"<Bar>echoh None<cr>
inorea aio_read	aio_read<c-o>:echoh HintHL<Bar>echo "int aio_read(struct aiocb * aiocbp)"<Bar>echoh None<cr>
inorea aio_return	aio_return<c-o>:echoh HintHL<Bar>echo "ssize_t aio_return(struct aiocb * aiocbp)"<Bar>echoh None<cr>
inorea aio_suspend	aio_suspend<c-o>:echoh HintHL<Bar>echo "int aio_suspend(const struct aiocb * const cblist [], int n, const struct timespec * timeout)"<Bar>echoh None<cr>
inorea aio_write	aio_write<c-o>:echoh HintHL<Bar>echo "int aio_write(struct aiocb * aiocbp)"<Bar>echoh None<cr>
inorea alloca	alloca<c-o>:echoh HintHL<Bar>echo "void *alloca(size_t size)"<Bar>echoh None<cr>
inorea alphasort	alphasort<c-o>:echoh HintHL<Bar>echo "int alphasort(const void * a, const void * b)"<Bar>echoh None<cr>
inorea argz_add	argz_add<c-o>:echoh HintHL<Bar>echo "argz_add(char ** argz, size_t * argz_len, const char * str)"<Bar>echoh None<cr>
inorea argz_count	argz_count<c-o>:echoh HintHL<Bar>echo "argz_count(const char * argz, size_t argz_len)"<Bar>echoh None<cr>
inorea argz_delete	argz_delete<c-o>:echoh HintHL<Bar>echo "argz_delete(char ** argz, size_t * argz_len, char * entry)"<Bar>echoh None<cr>
inorea argz_extract	argz_extract<c-o>:echoh HintHL<Bar>echo "argz_extract(char * argz, size_t argz_len, char ** argv)"<Bar>echoh None<cr>
inorea argz_next	argz_next<c-o>:echoh HintHL<Bar>echo "argz_next(char * argz, size_t argz_len, const char * entry)"<Bar>echoh None<cr>
inorea argz_stringify	argz_stringify<c-o>:echoh HintHL<Bar>echo "argz_stringify(char * argz, size_t len, int sep)"<Bar>echoh None<cr>
inorea asctime	asctime<c-o>:echoh HintHL<Bar>echo "char *asctime(const struct tm * tm)"<Bar>echoh None<cr>
inorea asctime_r	asctime_r<c-o>:echoh HintHL<Bar>echo "char *asctime_r(const struct tm * tm, char * buf)"<Bar>echoh None<cr>
inorea asin	asin<c-o>:echoh HintHL<Bar>echo "double asin(double x)"<Bar>echoh None<cr>
inorea asinf	asinf<c-o>:echoh HintHL<Bar>echo "float asinf(float x)"<Bar>echoh None<cr>
inorea asinh	asinh<c-o>:echoh HintHL<Bar>echo "double asinh(double x)"<Bar>echoh None<cr>
inorea asinhf	asinhf<c-o>:echoh HintHL<Bar>echo "float asinhf(float x)"<Bar>echoh None<cr>
inorea asprintf	asprintf<c-o>:echoh HintHL<Bar>echo "int asprintf(char ** strp, const char * fmt, ...)"<Bar>echoh None<cr>
inorea assert	assert<c-o>:echoh HintHL<Bar>echo "void assert(scalar expression)"<Bar>echoh None<cr>
inorea assert_perror	assert_perror<c-o>:echoh HintHL<Bar>echo "void assert_perror(int errnum)"<Bar>echoh None<cr>
inorea atan2	atan2<c-o>:echoh HintHL<Bar>echo "double atan2(double y, double x)"<Bar>echoh None<cr>
inorea atan2f	atan2f<c-o>:echoh HintHL<Bar>echo "float atan2f(float y, float x)"<Bar>echoh None<cr>
inorea atan2l	atan2l<c-o>:echoh HintHL<Bar>echo "long double atan2l(long double y, long double x)"<Bar>echoh None<cr>
inorea atan	atan<c-o>:echoh HintHL<Bar>echo "double atan(double x)"<Bar>echoh None<cr>
inorea atanh	atanh<c-o>:echoh HintHL<Bar>echo "double atanh(double x)"<Bar>echoh None<cr>
inorea atanhf	atanhf<c-o>:echoh HintHL<Bar>echo "float atanhf(float x)"<Bar>echoh None<cr>
inorea atanhl	atanhl<c-o>:echoh HintHL<Bar>echo "long double atanhl(long double x)"<Bar>echoh None<cr>
inorea atanl	atanl<c-o>:echoh HintHL<Bar>echo "long double atanl( long double x)"<Bar>echoh None<cr>
inorea atexit	atexit<c-o>:echoh HintHL<Bar>echo "int atexit(void (* function)(void))"<Bar>echoh None<cr>
inorea atof	atof<c-o>:echoh HintHL<Bar>echo "double atof(const char * nptr)"<Bar>echoh None<cr>
inorea atoi	atoi<c-o>:echoh HintHL<Bar>echo "int atoi(const char * nptr)"<Bar>echoh None<cr>
inorea atol	atol<c-o>:echoh HintHL<Bar>echo "long atol(const char * nptr)"<Bar>echoh None<cr>
inorea atoll	atoll<c-o>:echoh HintHL<Bar>echo "long long atoll(const char * nptr)"<Bar>echoh None<cr>
inorea atoq	atoq<c-o>:echoh HintHL<Bar>echo "long long atoq(const char * nptr)"<Bar>echoh None<cr>
inorea attr_get	attr_get<c-o>:echoh HintHL<Bar>echo "int attr_get(attr_t *attrs, short *pair, void *opts)"<Bar>echoh None<cr>
inorea attr_get	attr_get<c-o>:echoh HintHL<Bar>echo "int attr_get (const char *\f2path\f3, const char *\f2attrname\f3, char *\f2attrvalue\f3, int *\f2valuelength\f3, int \f2flags\f3)"<Bar>echoh None<cr>
inorea attr_getf	attr_getf<c-o>:echoh HintHL<Bar>echo "int attr_getf (int \f2fd\f3, const char *\f2attrname\f3, char *\f2attrvalue\f3, int *\f2valuelength\f3, int \f2flags\f3)"<Bar>echoh None<cr>
inorea attr_list	attr_list<c-o>:echoh HintHL<Bar>echo "int attr_list (const char \(**path, char \(**buffer, const int buffersize, int flags, attrlist_cursor_t \(**cursor)"<Bar>echoh None<cr>
inorea attr_listf	attr_listf<c-o>:echoh HintHL<Bar>echo "int attr_listf (int fd, char \(**buffer, const int buffersize, int flags, attrlist_cursor_t \(**cursor)"<Bar>echoh None<cr>
inorea attr_multi	attr_multi<c-o>:echoh HintHL<Bar>echo "int attr_multi (const char *\f2path\f3, attr_multiop_t *\f2oplist\f3, int \f2count\f3, int \f2flags\f3)"<Bar>echoh None<cr>
inorea attr_multif	attr_multif<c-o>:echoh HintHL<Bar>echo "int attr_multif (int \f2fd\f3, attr_multiop_t *\f2oplist\f3, int \f2count\f3, int \f2flags\f3)"<Bar>echoh None<cr>
inorea attr_off	attr_off<c-o>:echoh HintHL<Bar>echo "int attr_off(attr_t attrs, void *opts)"<Bar>echoh None<cr>
inorea attroff	attroff<c-o>:echoh HintHL<Bar>echo "int attroff(int attrs)"<Bar>echoh None<cr>
inorea attr_on	attr_on<c-o>:echoh HintHL<Bar>echo "int attr_on(attr_t attrs, void *opts)"<Bar>echoh None<cr>
inorea attron	attron<c-o>:echoh HintHL<Bar>echo "int attron(int attrs)"<Bar>echoh None<cr>
inorea attr_remove	attr_remove<c-o>:echoh HintHL<Bar>echo "int attr_remove (const char *\f2path\f3, const char *\f2attrname\f3, int \f2flags\f3)"<Bar>echoh None<cr>
inorea attr_removef	attr_removef<c-o>:echoh HintHL<Bar>echo "int attr_removef (int \f2fd\f3, const char *\f2attrname\f3, int \f2flags\f3)"<Bar>echoh None<cr>
inorea attr_set	attr_set<c-o>:echoh HintHL<Bar>echo "int attr_set(attr_t attrs, short pair, void *opts)"<Bar>echoh None<cr>
inorea attr_set	attr_set<c-o>:echoh HintHL<Bar>echo "int attr_set (const char *\f2path\f3, const char *\f2attrname\f3, const char *\f2attrvalue\f3, const int \f2valuelength\f3, int \f2flags\f3)"<Bar>echoh None<cr>
inorea attrset	attrset<c-o>:echoh HintHL<Bar>echo "int attrset(int attrs)"<Bar>echoh None<cr>
inorea attr_setf	attr_setf<c-o>:echoh HintHL<Bar>echo "int attr_setf (int \f2fd\f3, const char *\f2attrname\f3, const char *\f2attrvalue\f3, const int \f2valuelength\f3, int \f2flags\f3)"<Bar>echoh None<cr>
inorea avc_av_stats	avc_av_stats<c-o>:echoh HintHL<Bar>echo "void avc_av_stats(void)"<Bar>echoh None<cr>
inorea avc_cache_stats	avc_cache_stats<c-o>:echoh HintHL<Bar>echo "void avc_cache_stats(struct avc_cache_stats * stats)"<Bar>echoh None<cr>
inorea avc_cleanup	avc_cleanup<c-o>:echoh HintHL<Bar>echo "void avc_cleanup(void)"<Bar>echoh None<cr>
inorea avc_context_to_sid	avc_context_to_sid<c-o>:echoh HintHL<Bar>echo "int avc_context_to_sid(security_context_t ctx, security_id_t * sid)"<Bar>echoh None<cr>
inorea avc_destroy	avc_destroy<c-o>:echoh HintHL<Bar>echo "void avc_destroy(void)"<Bar>echoh None<cr>
inorea avc_entry_ref_init	avc_entry_ref_init<c-o>:echoh HintHL<Bar>echo "void avc_entry_ref_init(struct avc_entry_ref * aeref)"<Bar>echoh None<cr>
inorea avc_reset	avc_reset<c-o>:echoh HintHL<Bar>echo "int avc_reset(void)"<Bar>echoh None<cr>
inorea avc_sid_stats	avc_sid_stats<c-o>:echoh HintHL<Bar>echo "void avc_sid_stats(void)"<Bar>echoh None<cr>
inorea avc_sid_to_context	avc_sid_to_context<c-o>:echoh HintHL<Bar>echo "int avc_sid_to_context(security_id_t sid, security_context_t * ctx)"<Bar>echoh None<cr>
inorea basename	basename<c-o>:echoh HintHL<Bar>echo "char *basename(char * path)"<Bar>echoh None<cr>
inorea baudrate	baudrate<c-o>:echoh HintHL<Bar>echo "int baudrate(void)"<Bar>echoh None<cr>
inorea bcmp	bcmp<c-o>:echoh HintHL<Bar>echo "int bcmp(const void * s1, const void * s2, int n)"<Bar>echoh None<cr>
inorea bcmp	bcmp<c-o>:echoh HintHL<Bar>echo "int bcmp(const void * s1, const void * s2, size_t n)"<Bar>echoh None<cr>
inorea bcopy	bcopy<c-o>:echoh HintHL<Bar>echo "void bcopy(const void * src, void * dest, int n)"<Bar>echoh None<cr>
inorea bcopy	bcopy<c-o>:echoh HintHL<Bar>echo "void bcopy(const void * src, void * dest, size_t n)"<Bar>echoh None<cr>
inorea beep	beep<c-o>:echoh HintHL<Bar>echo "int beep(void)"<Bar>echoh None<cr>
inorea ber_alloc_t	ber_alloc_t<c-o>:echoh HintHL<Bar>echo "BerElement *ber_alloc_t(int options)"<Bar>echoh None<cr>
inorea ber_bvarray_add	ber_bvarray_add<c-o>:echoh HintHL<Bar>echo "void ber_bvarray_add(BerVarray * bvarray, BerValue * bv)"<Bar>echoh None<cr>
inorea ber_bvarray_free	ber_bvarray_free<c-o>:echoh HintHL<Bar>echo "void ber_bvarray_free(struct berval * bvarray)"<Bar>echoh None<cr>
inorea ber_bvdup	ber_bvdup<c-o>:echoh HintHL<Bar>echo "struct berval *ber_bvdup(const struct berval * bv)"<Bar>echoh None<cr>
inorea ber_bvecadd	ber_bvecadd<c-o>:echoh HintHL<Bar>echo "void ber_bvecadd(struct berval *** bvec, struct berval * bv)"<Bar>echoh None<cr>
inorea ber_bvecfree	ber_bvecfree<c-o>:echoh HintHL<Bar>echo "void ber_bvecfree(struct berval ** bvec)"<Bar>echoh None<cr>
inorea ber_bvfree	ber_bvfree<c-o>:echoh HintHL<Bar>echo "void ber_bvfree(struct berval * bv)"<Bar>echoh None<cr>
inorea ber_bvstr	ber_bvstr<c-o>:echoh HintHL<Bar>echo "struct berval *ber_bvstr(const char * str)"<Bar>echoh None<cr>
inorea ber_bvstrdup	ber_bvstrdup<c-o>:echoh HintHL<Bar>echo "struct berval *ber_bvstrdup(const char * str)"<Bar>echoh None<cr>
inorea ber_dupbv	ber_dupbv<c-o>:echoh HintHL<Bar>echo "struct berval *ber_dupbv(const struct berval * dst, struct berval * src)"<Bar>echoh None<cr>
inorea ber_first_element	ber_first_element<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_first_element(BerElement * ber, ber_len_t * len, char ** cookie)"<Bar>echoh None<cr>
inorea ber_flush	ber_flush<c-o>:echoh HintHL<Bar>echo "int ber_flush(Sockbuf * sb, BerElement * ber, int freeit)"<Bar>echoh None<cr>
inorea ber_free	ber_free<c-o>:echoh HintHL<Bar>echo "void ber_free(BerElement * ber, int freebuf)"<Bar>echoh None<cr>
inorea ber_get_bitstringa	ber_get_bitstringa<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_get_bitstringa(BerElement * ber, char ** buf, ber_len_t * blen)"<Bar>echoh None<cr>
inorea ber_get_boolean	ber_get_boolean<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_get_boolean(BerElement * ber, ber_int_t * bool)"<Bar>echoh None<cr>
inorea ber_get_enum	ber_get_enum<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_get_enum(BerElement * ber, ber_int_t * num)"<Bar>echoh None<cr>
inorea ber_get_int	ber_get_int<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_get_int(BerElement * ber, ber_int_t * num)"<Bar>echoh None<cr>
inorea ber_get_next	ber_get_next<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_get_next(Sockbuf * sb, ber_len_t * len, BerElement * ber)"<Bar>echoh None<cr>
inorea ber_get_null	ber_get_null<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_get_null(BerElement * ber)"<Bar>echoh None<cr>
inorea ber_get_stringa	ber_get_stringa<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_get_stringa(BerElement * ber, char ** buf)"<Bar>echoh None<cr>
inorea ber_get_stringal	ber_get_stringal<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_get_stringal(BerElement * ber, struct berval ** bv)"<Bar>echoh None<cr>
inorea ber_get_stringb	ber_get_stringb<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_get_stringb(BerElement * ber, char * buf, ber_len_t * len)"<Bar>echoh None<cr>
inorea ber_get_stringbv	ber_get_stringbv<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_get_stringbv(BerElement * ber, struct berval * bv, int alloc)"<Bar>echoh None<cr>
inorea ber_memalloc	ber_memalloc<c-o>:echoh HintHL<Bar>echo "void *ber_memalloc(ber_len_t bytes)"<Bar>echoh None<cr>
inorea ber_memcalloc	ber_memcalloc<c-o>:echoh HintHL<Bar>echo "void *ber_memcalloc(ber_len_t nelems, ber_len_t bytes)"<Bar>echoh None<cr>
inorea ber_memfree	ber_memfree<c-o>:echoh HintHL<Bar>echo "void ber_memfree(void * ptr)"<Bar>echoh None<cr>
inorea ber_memrealloc	ber_memrealloc<c-o>:echoh HintHL<Bar>echo "void *ber_memrealloc(void * ptr, ber_len_t bytes)"<Bar>echoh None<cr>
inorea ber_memvfree	ber_memvfree<c-o>:echoh HintHL<Bar>echo "void ber_memvfree(void ** vec)"<Bar>echoh None<cr>
inorea ber_next_element	ber_next_element<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_next_element(BerElement * ber, ber_len_t * len, const char * cookie)"<Bar>echoh None<cr>
inorea ber_peek_tag	ber_peek_tag<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_peek_tag(BerElement * ber, ber_len_t * len)"<Bar>echoh None<cr>
inorea ber_printf	ber_printf<c-o>:echoh HintHL<Bar>echo "int ber_printf(BerElement * ber, const char * fmt, ...)"<Bar>echoh None<cr>
inorea ber_put_bitstring	ber_put_bitstring<c-o>:echoh HintHL<Bar>echo "int ber_put_bitstring(BerElement * ber, const char * str, ber_len_t blen, ber_tag_t tag)"<Bar>echoh None<cr>
inorea ber_put_boolean	ber_put_boolean<c-o>:echoh HintHL<Bar>echo "int ber_put_boolean(BerElement * ber, ber_int_t bool, ber_tag_t tag)"<Bar>echoh None<cr>
inorea ber_put_enum	ber_put_enum<c-o>:echoh HintHL<Bar>echo "int ber_put_enum(BerElement * ber, ber_int_t num, ber_tag_t tag)"<Bar>echoh None<cr>
inorea ber_put_int	ber_put_int<c-o>:echoh HintHL<Bar>echo "int ber_put_int(BerElement * ber, ber_int_t num, ber_tag_t tag)"<Bar>echoh None<cr>
inorea ber_put_null	ber_put_null<c-o>:echoh HintHL<Bar>echo "int ber_put_null(BerElement * ber, ber_tag_t tag)"<Bar>echoh None<cr>
inorea ber_put_ostring	ber_put_ostring<c-o>:echoh HintHL<Bar>echo "int ber_put_ostring(BerElement * ber, const char * str, ber_len_t len, ber_tag_t tag)"<Bar>echoh None<cr>
inorea ber_put_seq	ber_put_seq<c-o>:echoh HintHL<Bar>echo "int ber_put_seq(BerElement * ber)"<Bar>echoh None<cr>
inorea ber_put_set	ber_put_set<c-o>:echoh HintHL<Bar>echo "int ber_put_set(BerElement * ber)"<Bar>echoh None<cr>
inorea ber_put_string	ber_put_string<c-o>:echoh HintHL<Bar>echo "int ber_put_string(BerElement * ber, const char * str, ber_tag_t tag)"<Bar>echoh None<cr>
inorea ber_scanf	ber_scanf<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_scanf(BerElement * ber, const char * fmt, ...)"<Bar>echoh None<cr>
inorea ber_skip_tag	ber_skip_tag<c-o>:echoh HintHL<Bar>echo "ber_tag_t ber_skip_tag(BerElement * ber, ber_len_t * len)"<Bar>echoh None<cr>
inorea ber_start_seq	ber_start_seq<c-o>:echoh HintHL<Bar>echo "int ber_start_seq(BerElement * ber, ber_tag_t tag)"<Bar>echoh None<cr>
inorea ber_start_set	ber_start_set<c-o>:echoh HintHL<Bar>echo "int ber_start_set(BerElement * ber, ber_tag_t tag)"<Bar>echoh None<cr>
inorea ber_str2bv	ber_str2bv<c-o>:echoh HintHL<Bar>echo "struct berval *ber_str2bv(const char * str, ber_len_t len, int dup, struct berval * bv)"<Bar>echoh None<cr>
inorea bindresvport	bindresvport<c-o>:echoh HintHL<Bar>echo "int bindresvport(sd, sin)"<Bar>echoh None<cr>
inorea bkgd	bkgd<c-o>:echoh HintHL<Bar>echo "int bkgd(chtype ch)"<Bar>echoh None<cr>
inorea bkgdset	bkgdset<c-o>:echoh HintHL<Bar>echo "void bkgdset(chtype ch)"<Bar>echoh None<cr>
inorea bkgrnd	bkgrnd<c-o>:echoh HintHL<Bar>echo "int bkgrnd( const cchar_t *wch)"<Bar>echoh None<cr>
inorea bkgrndset	bkgrndset<c-o>:echoh HintHL<Bar>echo "void bkgrndset(const cchar_t *wch)"<Bar>echoh None<cr>
inorea bool	bool<c-o>:echoh HintHL<Bar>echo " bool (* const field_check)(FIELD *, const void *), bool (* const char_check)(int, const void *))"<Bar>echoh None<cr>
inorea bool	bool<c-o>:echoh HintHL<Bar>echo " FIELDTYPE *fieldtype, bool (* const next_choice)(FIELD *, const void *), bool (* const prev_choice)(FIELD *, const void *))"<Bar>echoh None<cr>
inorea border	border<c-o>:echoh HintHL<Bar>echo "int border(chtype ls, chtype rs, chtype ts, chtype bs, chtype tl, chtype tr, chtype bl, chtype br)"<Bar>echoh None<cr>
inorea bottom_panel	bottom_panel<c-o>:echoh HintHL<Bar>echo "int bottom_panel(PANEL *pan)"<Bar>echoh None<cr>
inorea box	box<c-o>:echoh HintHL<Bar>echo "int box(WINDOW *win, chtype verch, chtype horch)"<Bar>echoh None<cr>
inorea bsearch	bsearch<c-o>:echoh HintHL<Bar>echo "void *bsearch(const void * key, const void * base, size_t nmemb, size_t size, int (* compar)(const void *, const void *))"<Bar>echoh None<cr>
inorea btowc	btowc<c-o>:echoh HintHL<Bar>echo "wint_t btowc(int c)"<Bar>echoh None<cr>
inorea bzero	bzero<c-o>:echoh HintHL<Bar>echo "void bzero(void * s, int n)"<Bar>echoh None<cr>
inorea bzero	bzero<c-o>:echoh HintHL<Bar>echo "void bzero(void * s, size_t n)"<Bar>echoh None<cr>
inorea cabs	cabs<c-o>:echoh HintHL<Bar>echo "double cabs(double complex z)"<Bar>echoh None<cr>
inorea cabsf	cabsf<c-o>:echoh HintHL<Bar>echo "float cabsf(float complex z)"<Bar>echoh None<cr>
inorea cabsl	cabsl<c-o>:echoh HintHL<Bar>echo "long double cabsl(long double complex z)"<Bar>echoh None<cr>
inorea cacoshf	cacoshf<c-o>:echoh HintHL<Bar>echo "float complex cacoshf(float complex z)"<Bar>echoh None<cr>
inorea cacoshl	cacoshl<c-o>:echoh HintHL<Bar>echo "long double complex cacoshl(long double complex z)"<Bar>echoh None<cr>
inorea calloc	calloc<c-o>:echoh HintHL<Bar>echo "void * calloc (size_t nelem, size_t elsize)"<Bar>echoh None<cr>
inorea calloc	calloc<c-o>:echoh HintHL<Bar>echo "void *calloc(size_t nmemb, size_t size)"<Bar>echoh None<cr>
inorea can_change_color	can_change_color<c-o>:echoh HintHL<Bar>echo "bool can_change_color(void)"<Bar>echoh None<cr>
inorea canonicalize_file_name	canonicalize_file_name<c-o>:echoh HintHL<Bar>echo "char *canonicalize_file_name (const char * path)"<Bar>echoh None<cr>
inorea cap_clear	cap_clear<c-o>:echoh HintHL<Bar>echo "int cap_clear(cap_t cap_p)"<Bar>echoh None<cr>
inorea cap_copy_ext	cap_copy_ext<c-o>:echoh HintHL<Bar>echo "ssize_t cap_copy_ext(void * ext_p, cap_t cap_p, ssize_t size)"<Bar>echoh None<cr>
inorea cap_copy_int	cap_copy_int<c-o>:echoh HintHL<Bar>echo "cap_t cap_copy_int(const void * ext_p)"<Bar>echoh None<cr>
inorea cap_dup	cap_dup<c-o>:echoh HintHL<Bar>echo "cap_t cap_dup(cap_t cap_p)"<Bar>echoh None<cr>
inorea cap_free	cap_free<c-o>:echoh HintHL<Bar>echo "int cap_free(void * obj_d)"<Bar>echoh None<cr>
inorea cap_from_text	cap_from_text<c-o>:echoh HintHL<Bar>echo "cap_t cap_from_text(const char * buf_p)"<Bar>echoh None<cr>
inorea cap_get_flag	cap_get_flag<c-o>:echoh HintHL<Bar>echo "int cap_get_flag(cap_t cap_p, cap_value_t cap, cap_flag_t flag, cap_flag_value_t * value_p)"<Bar>echoh None<cr>
inorea capgetp	capgetp<c-o>:echoh HintHL<Bar>echo "cap_t capgetp(pid_t pid, cap_t cap_d)"<Bar>echoh None<cr>
inorea cap_get_proc	cap_get_proc<c-o>:echoh HintHL<Bar>echo "cap_t cap_get_proc(void)"<Bar>echoh None<cr>
inorea cap_init	cap_init<c-o>:echoh HintHL<Bar>echo "cap_t cap_init(void)"<Bar>echoh None<cr>
inorea cap_set_flag	cap_set_flag<c-o>:echoh HintHL<Bar>echo "int cap_set_flag(cap_t cap_p, cap_flag_t flag, int ncap, cap_value_t * caps, cap_flag_value_t value)"<Bar>echoh None<cr>
inorea capsetp	capsetp<c-o>:echoh HintHL<Bar>echo "cap_t capsetp(pid_t pid, cap_t cap_d)"<Bar>echoh None<cr>
inorea cap_set_proc	cap_set_proc<c-o>:echoh HintHL<Bar>echo "int cap_set_proc(cap_t cap_p)"<Bar>echoh None<cr>
inorea cap_size	cap_size<c-o>:echoh HintHL<Bar>echo "ssize_t cap_size(cap_t cap_p)"<Bar>echoh None<cr>
inorea cap_to_text	cap_to_text<c-o>:echoh HintHL<Bar>echo "char *cap_to_text(cap_t caps, ssize_t * length_p)"<Bar>echoh None<cr>
inorea carg	carg<c-o>:echoh HintHL<Bar>echo "double carg(double complex z)"<Bar>echoh None<cr>
inorea cargf	cargf<c-o>:echoh HintHL<Bar>echo "float cargf(float complex z)"<Bar>echoh None<cr>
inorea cargl	cargl<c-o>:echoh HintHL<Bar>echo "long double cargl(long double complex z)"<Bar>echoh None<cr>
inorea casinhf	casinhf<c-o>:echoh HintHL<Bar>echo "float complex casinhf(float complex z)"<Bar>echoh None<cr>
inorea casinhl	casinhl<c-o>:echoh HintHL<Bar>echo "long double complex casinhl(long double complex z)"<Bar>echoh None<cr>
inorea catanhf	catanhf<c-o>:echoh HintHL<Bar>echo "float complex catanhf(float complex z)"<Bar>echoh None<cr>
inorea catanhl	catanhl<c-o>:echoh HintHL<Bar>echo "long double complex catanhl(long double complex z)"<Bar>echoh None<cr>
inorea catclose	catclose<c-o>:echoh HintHL<Bar>echo "int catclose(nl_catd catalog)"<Bar>echoh None<cr>
inorea catgets	catgets<c-o>:echoh HintHL<Bar>echo "char *catgets(nl_catd catalog, int set_number, int message_number, const char * message)"<Bar>echoh None<cr>
inorea catopen	catopen<c-o>:echoh HintHL<Bar>echo "nl_catd catopen(const char * name, int flag)"<Bar>echoh None<cr>
inorea cbc_crypt	cbc_crypt<c-o>:echoh HintHL<Bar>echo "int cbc_crypt(char * key, char * data, unsigned datalen, unsigned mode, char * ivec)"<Bar>echoh None<cr>
inorea cbreak	cbreak<c-o>:echoh HintHL<Bar>echo "int cbreak(void)"<Bar>echoh None<cr>
inorea cbrt	cbrt<c-o>:echoh HintHL<Bar>echo "double cbrt(double x)"<Bar>echoh None<cr>
inorea cbrtf	cbrtf<c-o>:echoh HintHL<Bar>echo "float cbrtf(float x)"<Bar>echoh None<cr>
inorea cbrtl	cbrtl<c-o>:echoh HintHL<Bar>echo "long double cbrtl(long double x)"<Bar>echoh None<cr>
inorea ccos	ccos<c-o>:echoh HintHL<Bar>echo "double complex ccos(double complex z)"<Bar>echoh None<cr>
inorea ccosf	ccosf<c-o>:echoh HintHL<Bar>echo "float complex ccosf(float complex z)"<Bar>echoh None<cr>
inorea ccosh	ccosh<c-o>:echoh HintHL<Bar>echo "double complex ccosh(double complex z)"<Bar>echoh None<cr>
inorea ccoshf	ccoshf<c-o>:echoh HintHL<Bar>echo "float complex ccoshf(float complex z)"<Bar>echoh None<cr>
inorea ccoshl	ccoshl<c-o>:echoh HintHL<Bar>echo "long double complex ccoshl(long double complex z)"<Bar>echoh None<cr>
inorea ccosl	ccosl<c-o>:echoh HintHL<Bar>echo "long double complex ccosl(long double complex z)"<Bar>echoh None<cr>
inorea ceil	ceil<c-o>:echoh HintHL<Bar>echo "double ceil(double x)"<Bar>echoh None<cr>
inorea ceilf	ceilf<c-o>:echoh HintHL<Bar>echo "float ceilf(float x)"<Bar>echoh None<cr>
inorea ceill	ceill<c-o>:echoh HintHL<Bar>echo "long double ceill(long double x)"<Bar>echoh None<cr>
inorea cerfc	cerfc<c-o>:echoh HintHL<Bar>echo "double complex cerfc(double complex z)"<Bar>echoh None<cr>
inorea cerf	cerf<c-o>:echoh HintHL<Bar>echo "double complex cerf(double complex z)"<Bar>echoh None<cr>
inorea cerfcf	cerfcf<c-o>:echoh HintHL<Bar>echo "float complex cerfcf(float complex z)"<Bar>echoh None<cr>
inorea cerfcl	cerfcl<c-o>:echoh HintHL<Bar>echo "long double complex cerfcl(long double complex z)"<Bar>echoh None<cr>
inorea cerff	cerff<c-o>:echoh HintHL<Bar>echo "float complex cerff(float complex z)"<Bar>echoh None<cr>
inorea cerfl	cerfl<c-o>:echoh HintHL<Bar>echo "long double complex cerfl(long double complex z)"<Bar>echoh None<cr>
inorea cexp2	cexp2<c-o>:echoh HintHL<Bar>echo "double complex cexp2(double complex z)"<Bar>echoh None<cr>
inorea cexp2f	cexp2f<c-o>:echoh HintHL<Bar>echo "float complex cexp2f(float complex z)"<Bar>echoh None<cr>
inorea cexp2l	cexp2l<c-o>:echoh HintHL<Bar>echo "long double complex cexp2l(long double complex z)"<Bar>echoh None<cr>
inorea cexp	cexp<c-o>:echoh HintHL<Bar>echo "double complex cexp(double complex z)"<Bar>echoh None<cr>
inorea cexpf	cexpf<c-o>:echoh HintHL<Bar>echo "float complex cexpf(float complex z)"<Bar>echoh None<cr>
inorea cexpl	cexpl<c-o>:echoh HintHL<Bar>echo "long double complex cexpl(long double complex z)"<Bar>echoh None<cr>
inorea cfgetispeed	cfgetispeed<c-o>:echoh HintHL<Bar>echo "speed_t cfgetispeed(const struct termios * termios_p)"<Bar>echoh None<cr>
inorea cfgetospeed	cfgetospeed<c-o>:echoh HintHL<Bar>echo "speed_t cfgetospeed(const struct termios * termios_p)"<Bar>echoh None<cr>
inorea cfmakeraw	cfmakeraw<c-o>:echoh HintHL<Bar>echo "void cfmakeraw(struct termios * termios_p)"<Bar>echoh None<cr>
inorea cfree	cfree<c-o>:echoh HintHL<Bar>echo "int cfree(void * ptr)"<Bar>echoh None<cr>
inorea cfree	cfree<c-o>:echoh HintHL<Bar>echo "void cfree(char * ptr, unsigned num, unsigned size)"<Bar>echoh None<cr>
inorea cfree	cfree<c-o>:echoh HintHL<Bar>echo "void cfree(void * ptr)"<Bar>echoh None<cr>
inorea cfree	cfree<c-o>:echoh HintHL<Bar>echo "void cfree(void * ptr, size_t nelem, size_t elsize)"<Bar>echoh None<cr>
inorea cfsetispeed	cfsetispeed<c-o>:echoh HintHL<Bar>echo "int cfsetispeed(struct termios * termios_p, speed_t speed)"<Bar>echoh None<cr>
inorea cfsetospeed	cfsetospeed<c-o>:echoh HintHL<Bar>echo "int cfsetospeed(struct termios * termios_p, speed_t speed)"<Bar>echoh None<cr>
inorea checkPasswdAccess	checkPasswdAccess<c-o>:echoh HintHL<Bar>echo "int checkPasswdAccess(access_vector_t requested)"<Bar>echoh None<cr>
inorea chgat	chgat<c-o>:echoh HintHL<Bar>echo "int chgat(int n, attr_t attr, short color, const void *opts)"<Bar>echoh None<cr>
inorea cimagf	cimagf<c-o>:echoh HintHL<Bar>echo "float cimagf(float complex z)"<Bar>echoh None<cr>
inorea cimagl	cimagl<c-o>:echoh HintHL<Bar>echo "long double cimagl(long double complex z)"<Bar>echoh None<cr>
inorea clear	clear<c-o>:echoh HintHL<Bar>echo "int clear(void)"<Bar>echoh None<cr>
inorea clearenv	clearenv<c-o>:echoh HintHL<Bar>echo "int clearenv(void)"<Bar>echoh None<cr>
inorea clearerr	clearerr<c-o>:echoh HintHL<Bar>echo "void clearerr(FILE * stream)"<Bar>echoh None<cr>
inorea clearerr_unlocked	clearerr_unlocked<c-o>:echoh HintHL<Bar>echo "void clearerr_unlocked(FILE * stream)"<Bar>echoh None<cr>
inorea clearok	clearok<c-o>:echoh HintHL<Bar>echo "int clearok(WINDOW *win, bool bf)"<Bar>echoh None<cr>
inorea clock	clock<c-o>:echoh HintHL<Bar>echo "clock_t clock(void)"<Bar>echoh None<cr>
inorea clock_getres	clock_getres<c-o>:echoh HintHL<Bar>echo "int clock_getres(clockid_t clk_id, struct timespec * res)"<Bar>echoh None<cr>
inorea clock_gettime	clock_gettime<c-o>:echoh HintHL<Bar>echo "int clock_gettime(clockid_t clk_id, struct timespec * tp)"<Bar>echoh None<cr>
inorea clock_settime	clock_settime<c-o>:echoh HintHL<Bar>echo "int clock_settime(clockid_t clk_id, const struct timespec * tp)"<Bar>echoh None<cr>
inorea clog10	clog10<c-o>:echoh HintHL<Bar>echo "double complex clog10(double complex z)"<Bar>echoh None<cr>
inorea clog10f	clog10f<c-o>:echoh HintHL<Bar>echo "float complex clog10f(float complex z)"<Bar>echoh None<cr>
inorea clog10l	clog10l<c-o>:echoh HintHL<Bar>echo "long double complex clog10l(long double complex z)"<Bar>echoh None<cr>
inorea clog2	clog2<c-o>:echoh HintHL<Bar>echo "double complex clog2(double complex z)"<Bar>echoh None<cr>
inorea clog2f	clog2f<c-o>:echoh HintHL<Bar>echo "float complex clog2f(float complex z)"<Bar>echoh None<cr>
inorea clog2l	clog2l<c-o>:echoh HintHL<Bar>echo "long double complex clog2l(long double complex z)"<Bar>echoh None<cr>
inorea clog	clog<c-o>:echoh HintHL<Bar>echo "double complex clog(double complex z)"<Bar>echoh None<cr>
inorea clogf	clogf<c-o>:echoh HintHL<Bar>echo "float complex clogf(float complex z)"<Bar>echoh None<cr>
inorea clogl	clogl<c-o>:echoh HintHL<Bar>echo "long double complex clogl(long double complex z)"<Bar>echoh None<cr>
inorea closedir	closedir<c-o>:echoh HintHL<Bar>echo "int closedir(DIR * dir)"<Bar>echoh None<cr>
inorea closelog	closelog<c-o>:echoh HintHL<Bar>echo "void closelog(void)"<Bar>echoh None<cr>
inorea clrtobot	clrtobot<c-o>:echoh HintHL<Bar>echo "int clrtobot(void)"<Bar>echoh None<cr>
inorea clrtoeol	clrtoeol<c-o>:echoh HintHL<Bar>echo "int clrtoeol(void)"<Bar>echoh None<cr>
inorea CMSG_ALIGN	CMSG_ALIGN<c-o>:echoh HintHL<Bar>echo "size_t CMSG_ALIGN(size_t length)"<Bar>echoh None<cr>
inorea CMSG_FIRSTHDR	CMSG_FIRSTHDR<c-o>:echoh HintHL<Bar>echo "struct cmsghdr *CMSG_FIRSTHDR(struct msghdr * msgh)"<Bar>echoh None<cr>
inorea CMSG_LEN	CMSG_LEN<c-o>:echoh HintHL<Bar>echo "size_t CMSG_LEN(size_t length)"<Bar>echoh None<cr>
inorea CMSG_NXTHDR	CMSG_NXTHDR<c-o>:echoh HintHL<Bar>echo "struct cmsghdr *CMSG_NXTHDR(struct msghdr * msgh, struct cmsghdr * cmsg)"<Bar>echoh None<cr>
inorea CMSG_SPACE	CMSG_SPACE<c-o>:echoh HintHL<Bar>echo "size_t CMSG_SPACE(size_t length)"<Bar>echoh None<cr>
inorea color_content	color_content<c-o>:echoh HintHL<Bar>echo "int color_content(short color, short *r, short *g, short *b)"<Bar>echoh None<cr>
inorea color_set	color_set<c-o>:echoh HintHL<Bar>echo "int color_set(short color_pair_number, void* opts)"<Bar>echoh None<cr>
inorea com_err	com_err<c-o>:echoh HintHL<Bar>echo "void com_err (const char *whoami, long code, const char *format, ...)"<Bar>echoh None<cr>
inorea confstr	confstr<c-o>:echoh HintHL<Bar>echo "size_t confstr(int name, char * buf, size_t len)"<Bar>echoh None<cr>
inorea context_free	context_free<c-o>:echoh HintHL<Bar>echo "void context_free(context_t con)"<Bar>echoh None<cr>
inorea context_new	context_new<c-o>:echoh HintHL<Bar>echo "context_t context_new(const char * context_str)"<Bar>echoh None<cr>
inorea context_range_get	context_range_get<c-o>:echoh HintHL<Bar>echo "const char * context_range_get(context_t con)"<Bar>echoh None<cr>
inorea context_range_set	context_range_set<c-o>:echoh HintHL<Bar>echo "const char * context_range_set(context_t con, const char* range)"<Bar>echoh None<cr>
inorea context_role_get	context_role_get<c-o>:echoh HintHL<Bar>echo "const char * context_role_get(context_t con)"<Bar>echoh None<cr>
inorea context_role_set	context_role_set<c-o>:echoh HintHL<Bar>echo "const char * context_role_set(context_t con, const char* role)"<Bar>echoh None<cr>
inorea context_str	context_str<c-o>:echoh HintHL<Bar>echo "const char * context_str(context_t con)"<Bar>echoh None<cr>
inorea context_type_get	context_type_get<c-o>:echoh HintHL<Bar>echo "const char * context_type_get(context_t con)"<Bar>echoh None<cr>
inorea context_type_set	context_type_set<c-o>:echoh HintHL<Bar>echo "const char * context_type_set(context_t con, const char* type)"<Bar>echoh None<cr>
inorea context_user_get	context_user_get<c-o>:echoh HintHL<Bar>echo "const char * context_user_get(context_t con)"<Bar>echoh None<cr>
inorea context_user_set	context_user_set<c-o>:echoh HintHL<Bar>echo "const char * context_user_set(context_t con, const char* user)"<Bar>echoh None<cr>
inorea copysign	copysign<c-o>:echoh HintHL<Bar>echo "double copysign(double x, double y)"<Bar>echoh None<cr>
inorea copysignf	copysignf<c-o>:echoh HintHL<Bar>echo "float copysignf(float x, float y)"<Bar>echoh None<cr>
inorea copysignl	copysignl<c-o>:echoh HintHL<Bar>echo "long double copysignl(long double x, long double y)"<Bar>echoh None<cr>
inorea copywin	copywin<c-o>:echoh HintHL<Bar>echo "int copywin(const WINDOW *srcwin, WINDOW *dstwin, int sminrow, int smincol, int dminrow, int dmincol, int dmaxrow, int dmaxcol, int overlay)"<Bar>echoh None<cr>
inorea cos	cos<c-o>:echoh HintHL<Bar>echo "double cos(double x)"<Bar>echoh None<cr>
inorea cosf	cosf<c-o>:echoh HintHL<Bar>echo "float cosf(float x)"<Bar>echoh None<cr>
inorea cosh	cosh<c-o>:echoh HintHL<Bar>echo "double cosh(double x)"<Bar>echoh None<cr>
inorea coshf	coshf<c-o>:echoh HintHL<Bar>echo "float coshf(float x)"<Bar>echoh None<cr>
inorea coshl	coshl<c-o>:echoh HintHL<Bar>echo "long double coshl(long double x)"<Bar>echoh None<cr>
inorea cosl	cosl<c-o>:echoh HintHL<Bar>echo "long double cosl(long double x)"<Bar>echoh None<cr>
inorea cpow	cpow<c-o>:echoh HintHL<Bar>echo "double complex cpow(double complex x, complex double z)"<Bar>echoh None<cr>
inorea cpowf	cpowf<c-o>:echoh HintHL<Bar>echo "float complex cpowf(float complex x, complex float z)"<Bar>echoh None<cr>
inorea cpowl	cpowl<c-o>:echoh HintHL<Bar>echo "long double complex cpowl(long double complex x, complex long double z)"<Bar>echoh None<cr>
inorea cproj	cproj<c-o>:echoh HintHL<Bar>echo "double complex cproj(double complex z)"<Bar>echoh None<cr>
inorea cprojf	cprojf<c-o>:echoh HintHL<Bar>echo "float complex cprojf(float complex z)"<Bar>echoh None<cr>
inorea cprojl	cprojl<c-o>:echoh HintHL<Bar>echo "long double complex cprojl(long double complex z)"<Bar>echoh None<cr>
inorea creal	creal<c-o>:echoh HintHL<Bar>echo "double creal(double complex z)"<Bar>echoh None<cr>
inorea crealf	crealf<c-o>:echoh HintHL<Bar>echo "float crealf(float complex z)"<Bar>echoh None<cr>
inorea creall	creall<c-o>:echoh HintHL<Bar>echo "long double creall(long double complex z)"<Bar>echoh None<cr>
inorea crypt	crypt<c-o>:echoh HintHL<Bar>echo "char *crypt(const char * key, const char * salt)"<Bar>echoh None<cr>
inorea csin	csin<c-o>:echoh HintHL<Bar>echo "double complex csin(double complex z)"<Bar>echoh None<cr>
inorea csinf	csinf<c-o>:echoh HintHL<Bar>echo "float complex csinf(float complex z)"<Bar>echoh None<cr>
inorea csinh	csinh<c-o>:echoh HintHL<Bar>echo "double complex csinh(double complex z)"<Bar>echoh None<cr>
inorea csinhf	csinhf<c-o>:echoh HintHL<Bar>echo "float complex csinhf(float complex z)"<Bar>echoh None<cr>
inorea csinhl	csinhl<c-o>:echoh HintHL<Bar>echo "long double complex csinhl(long double complex z)"<Bar>echoh None<cr>
inorea csinl	csinl<c-o>:echoh HintHL<Bar>echo "long double complex csinl(long double complex z)"<Bar>echoh None<cr>
inorea csqrt	csqrt<c-o>:echoh HintHL<Bar>echo "double complex csqrt(double complex z)"<Bar>echoh None<cr>
inorea csqrtf	csqrtf<c-o>:echoh HintHL<Bar>echo "float complex csqrtf(float complex z)"<Bar>echoh None<cr>
inorea csqrtl	csqrtl<c-o>:echoh HintHL<Bar>echo "long double complex csqrtl(long double complex z)"<Bar>echoh None<cr>
inorea ctan	ctan<c-o>:echoh HintHL<Bar>echo "double complex ctan(double complex z)"<Bar>echoh None<cr>
inorea ctanf	ctanf<c-o>:echoh HintHL<Bar>echo "float complex ctanf(float complex z)"<Bar>echoh None<cr>
inorea ctanh	ctanh<c-o>:echoh HintHL<Bar>echo "double complex ctanh(double complex z)"<Bar>echoh None<cr>
inorea ctanhf	ctanhf<c-o>:echoh HintHL<Bar>echo "float complex ctanhf(float complex z)"<Bar>echoh None<cr>
inorea ctanhl	ctanhl<c-o>:echoh HintHL<Bar>echo "long double complex ctanhl(long double complex z)"<Bar>echoh None<cr>
inorea ctanl	ctanl<c-o>:echoh HintHL<Bar>echo "long double complex ctanl(long double complex z)"<Bar>echoh None<cr>
inorea ctermid	ctermid<c-o>:echoh HintHL<Bar>echo "char *ctermid(char * s)"<Bar>echoh None<cr>
inorea ctime	ctime<c-o>:echoh HintHL<Bar>echo "char *ctime(const time_t * timep)"<Bar>echoh None<cr>
inorea ctime_r	ctime_r<c-o>:echoh HintHL<Bar>echo "char *ctime_r(const time_t * timep, char * buf)"<Bar>echoh None<cr>
inorea curl_easy_cleanup	curl_easy_cleanup<c-o>:echoh HintHL<Bar>echo "void curl_easy_cleanup(CURL * handle)"<Bar>echoh None<cr>
inorea curl_easy_duphandle	curl_easy_duphandle<c-o>:echoh HintHL<Bar>echo "CURL *curl_easy_duphandle(CURL *handle)"<Bar>echoh None<cr>
inorea curl_easy_escape	curl_easy_escape<c-o>:echoh HintHL<Bar>echo "char *curl_easy_escape( CURL * curl, char * url, int length)"<Bar>echoh None<cr>
inorea curl_easy_getinfo	curl_easy_getinfo<c-o>:echoh HintHL<Bar>echo "CURLcode curl_easy_getinfo(CURL *curl, CURLINFO info, ...)"<Bar>echoh None<cr>
inorea curl_easy_init	curl_easy_init<c-o>:echoh HintHL<Bar>echo "CURL *curl_easy_init()"<Bar>echoh None<cr>
inorea curl_easy_perform	curl_easy_perform<c-o>:echoh HintHL<Bar>echo "CURLcode curl_easy_perform(CURL * handle)"<Bar>echoh None<cr>
inorea curl_easy_reset	curl_easy_reset<c-o>:echoh HintHL<Bar>echo "void curl_easy_reset(CURL *handle)"<Bar>echoh None<cr>
inorea curl_easy_setopt	curl_easy_setopt<c-o>:echoh HintHL<Bar>echo "CURLcode curl_easy_setopt(CURL *handle, CURLoption option, parameter)"<Bar>echoh None<cr>
inorea curl_easy_strerror	curl_easy_strerror<c-o>:echoh HintHL<Bar>echo "const char *curl_easy_strerror(CURLcode errornum)"<Bar>echoh None<cr>
inorea curl_escape	curl_escape<c-o>:echoh HintHL<Bar>echo "char *curl_escape( char * url, int length)"<Bar>echoh None<cr>
inorea curl_formadd	curl_formadd<c-o>:echoh HintHL<Bar>echo "CURLFORMcode curl_formadd(struct curl_httppost ** firstitem, struct curl_httppost ** lastitem, ...)"<Bar>echoh None<cr>
inorea curl_formfree	curl_formfree<c-o>:echoh HintHL<Bar>echo "void curl_formfree(struct curl_httppost * form)"<Bar>echoh None<cr>
inorea curl_formget	curl_formget<c-o>:echoh HintHL<Bar>echo "void curl_formget(struct curl_httppost * form, void * arg, curl_formget_callback append)"<Bar>echoh None<cr>
inorea curl_free	curl_free<c-o>:echoh HintHL<Bar>echo "void curl_free( char * ptr)"<Bar>echoh None<cr>
inorea curl_getdate	curl_getdate<c-o>:echoh HintHL<Bar>echo "time_t curl_getdate(char * datestring, time_t *now)"<Bar>echoh None<cr>
inorea curl_getenv	curl_getenv<c-o>:echoh HintHL<Bar>echo "char *curl_getenv(const char * name)"<Bar>echoh None<cr>
inorea curl_global_cleanup	curl_global_cleanup<c-o>:echoh HintHL<Bar>echo "void curl_global_cleanup(void)"<Bar>echoh None<cr>
inorea curl_global_init	curl_global_init<c-o>:echoh HintHL<Bar>echo "CURLcode curl_global_init(long flags)"<Bar>echoh None<cr>
inorea curl_global_init_mem	curl_global_init_mem<c-o>:echoh HintHL<Bar>echo "CURLcode curl_global_init_mem(long flags, curl_malloc_callback m, curl_free_callback f, curl_realloc_callback r, curl_strdup_callback s, curl_calloc_callback c)"<Bar>echoh None<cr>
inorea curl_maprintf	curl_maprintf<c-o>:echoh HintHL<Bar>echo "char *curl_maprintf(const char * format, ...)"<Bar>echoh None<cr>
inorea curl_mfprintf	curl_mfprintf<c-o>:echoh HintHL<Bar>echo "int curl_mfprintf(FILE * fd, const char * format, ...)"<Bar>echoh None<cr>
inorea curl_mprintf	curl_mprintf<c-o>:echoh HintHL<Bar>echo "int curl_mprintf(const char * format, ...)"<Bar>echoh None<cr>
inorea curl_msnprintf	curl_msnprintf<c-o>:echoh HintHL<Bar>echo "int curl_msnprintf(char * buffer, size_t maxlength, const char * format, ...)"<Bar>echoh None<cr>
inorea curl_msprintf	curl_msprintf<c-o>:echoh HintHL<Bar>echo "int curl_msprintf(char * buffer, const char * format, ...)"<Bar>echoh None<cr>
inorea curl_multi_add_handle	curl_multi_add_handle<c-o>:echoh HintHL<Bar>echo "CURLMcode curl_multi_add_handle(CURLM *multi_handle, CURL *easy_handle)"<Bar>echoh None<cr>
inorea curl_multi_assign	curl_multi_assign<c-o>:echoh HintHL<Bar>echo "CURLMcode curl_multi_assign(CURLM *multi_handle, curl_socket_t sockfd, void *sockptr)"<Bar>echoh None<cr>
inorea curl_multi_cleanup	curl_multi_cleanup<c-o>:echoh HintHL<Bar>echo "CURLMcode curl_multi_cleanup( CURLM *multi_handle)"<Bar>echoh None<cr>
inorea curl_multi_fdset	curl_multi_fdset<c-o>:echoh HintHL<Bar>echo "CURLMcode curl_multi_fdset(CURLM *multi_handle, fd_set *read_fd_set, fd_set *write_fd_set, fd_set *exc_fd_set, int *max_fd)"<Bar>echoh None<cr>
inorea curl_multi_info_read	curl_multi_info_read<c-o>:echoh HintHL<Bar>echo "CURLMsg *curl_multi_info_read( CURLM *multi_handle, int *msgs_in_queue)"<Bar>echoh None<cr>
inorea curl_multi_init	curl_multi_init<c-o>:echoh HintHL<Bar>echo "CURLM *curl_multi_init()"<Bar>echoh None<cr>
inorea curl_multi_perform	curl_multi_perform<c-o>:echoh HintHL<Bar>echo "CURLMcode curl_multi_perform(CURLM *multi_handle, int *running_handles)"<Bar>echoh None<cr>
inorea curl_multi_remove_handle	curl_multi_remove_handle<c-o>:echoh HintHL<Bar>echo "CURLMcode curl_multi_remove_handle(CURLM *multi_handle, CURL *easy_handle)"<Bar>echoh None<cr>
inorea curl_multi_setopt	curl_multi_setopt<c-o>:echoh HintHL<Bar>echo "CURLMcode curl_multi_setopt(CURLM * multi_handle, CURLMoption option, param)"<Bar>echoh None<cr>
inorea curl_multi_socket_all	curl_multi_socket_all<c-o>:echoh HintHL<Bar>echo "CURLMcode curl_multi_socket_all(CURLM *multi_handle, int *running_handles)"<Bar>echoh None<cr>
inorea curl_multi_socket	curl_multi_socket<c-o>:echoh HintHL<Bar>echo "CURLMcode curl_multi_socket(CURLM * multi_handle, curl_socket_t sockfd, int *running_handles)"<Bar>echoh None<cr>
inorea curl_multi_strerror	curl_multi_strerror<c-o>:echoh HintHL<Bar>echo "const char *curl_multi_strerror(CURLMcode errornum)"<Bar>echoh None<cr>
inorea curl_multi_timeout	curl_multi_timeout<c-o>:echoh HintHL<Bar>echo "CURLMcode curl_multi_timeout(CURLM *multi_handle, long *timeout)"<Bar>echoh None<cr>
inorea curl_mvaprintf	curl_mvaprintf<c-o>:echoh HintHL<Bar>echo "char *curl_mvaprintf(const char * format, va_list args)"<Bar>echoh None<cr>
inorea curl_mvfprintf	curl_mvfprintf<c-o>:echoh HintHL<Bar>echo "int curl_mvfprintf(FILE * fd, const char * format, va_list args)"<Bar>echoh None<cr>
inorea curl_mvprintf	curl_mvprintf<c-o>:echoh HintHL<Bar>echo "int curl_mvprintf(const char * format, va_list args)"<Bar>echoh None<cr>
inorea curl_mvsnprintf	curl_mvsnprintf<c-o>:echoh HintHL<Bar>echo "int curl_mvsnprintf(char * buffer, size_t maxlength, const char * format, va_list args)"<Bar>echoh None<cr>
inorea curl_mvsprintf	curl_mvsprintf<c-o>:echoh HintHL<Bar>echo "int curl_mvsprintf(char * buffer, const char * format, va_list args)"<Bar>echoh None<cr>
inorea curl_share_cleanup	curl_share_cleanup<c-o>:echoh HintHL<Bar>echo "CURLSHcode curl_share_cleanup(CURLSH * share_handle)"<Bar>echoh None<cr>
inorea curl_share_init	curl_share_init<c-o>:echoh HintHL<Bar>echo "CURLSH *curl_share_init()"<Bar>echoh None<cr>
inorea curl_share_setopt	curl_share_setopt<c-o>:echoh HintHL<Bar>echo "CURLSHcode curl_share_setopt(CURLSH *share, CURLSHoption option, parameter)"<Bar>echoh None<cr>
inorea curl_share_strerror	curl_share_strerror<c-o>:echoh HintHL<Bar>echo "const char *curl_share_strerror(CURLSHcode errornum)"<Bar>echoh None<cr>
inorea curl_slist_append	curl_slist_append<c-o>:echoh HintHL<Bar>echo "struct curl_slist *curl_slist_append(struct curl_slist * list, const char * string)"<Bar>echoh None<cr>
inorea curl_slist_free_all	curl_slist_free_all<c-o>:echoh HintHL<Bar>echo "void curl_slist_free_all(struct curl_slist * list)"<Bar>echoh None<cr>
inorea curl_strenqual	curl_strenqual<c-o>:echoh HintHL<Bar>echo "int curl_strenqual(char * str1, char * str2, size_t len)"<Bar>echoh None<cr>
inorea curl_strequal	curl_strequal<c-o>:echoh HintHL<Bar>echo "int curl_strequal(char * str1, char * str2)"<Bar>echoh None<cr>
inorea curl_unescape	curl_unescape<c-o>:echoh HintHL<Bar>echo "char *curl_unescape( char * url, int length)"<Bar>echoh None<cr>
inorea curl_version	curl_version<c-o>:echoh HintHL<Bar>echo "char *curl_version()"<Bar>echoh None<cr>
inorea curl_version_info	curl_version_info<c-o>:echoh HintHL<Bar>echo "curl_version_info_data *curl_version_info( CURLversion type)"<Bar>echoh None<cr>
inorea current_field	current_field<c-o>:echoh HintHL<Bar>echo "FIELD *current_field(const FORM *)"<Bar>echoh None<cr>
inorea current_item	current_item<c-o>:echoh HintHL<Bar>echo "ITEM *current_item(const MENU *menu)"<Bar>echoh None<cr>
inorea curs_set	curs_set<c-o>:echoh HintHL<Bar>echo "int curs_set(int visibility)"<Bar>echoh None<cr>
inorea cuserid	cuserid<c-o>:echoh HintHL<Bar>echo "char *cuserid(char * string)"<Bar>echoh None<cr>
inorea daemon	daemon<c-o>:echoh HintHL<Bar>echo "int daemon(int nochdir, int noclose)"<Bar>echoh None<cr>
inorea data_ahead	data_ahead<c-o>:echoh HintHL<Bar>echo "bool data_ahead(const FORM *form)"<Bar>echoh None<cr>
inorea data_behind	data_behind<c-o>:echoh HintHL<Bar>echo "bool data_behind(const FORM *form)"<Bar>echoh None<cr>
inorea dbm_clearerr	dbm_clearerr<c-o>:echoh HintHL<Bar>echo "dbm_clearerr (file)"<Bar>echoh None<cr>
inorea dbmclose	dbmclose<c-o>:echoh HintHL<Bar>echo "dbmclose ()"<Bar>echoh None<cr>
inorea dbm_close	dbm_close<c-o>:echoh HintHL<Bar>echo "dbm_close (file)"<Bar>echoh None<cr>
inorea dbm_delete	dbm_delete<c-o>:echoh HintHL<Bar>echo "dbm_delete (file, key)"<Bar>echoh None<cr>
inorea dbm_dirfno	dbm_dirfno<c-o>:echoh HintHL<Bar>echo "dbm_dirfno (file)"<Bar>echoh None<cr>
inorea dbm_error	dbm_error<c-o>:echoh HintHL<Bar>echo "dbm_error (file)"<Bar>echoh None<cr>
inorea dbm_fetch	dbm_fetch<c-o>:echoh HintHL<Bar>echo "dbm_fetch (file, key)"<Bar>echoh None<cr>
inorea dbm_firstkey	dbm_firstkey<c-o>:echoh HintHL<Bar>echo "dbm_firstkey (file)"<Bar>echoh None<cr>
inorea dbminit	dbminit<c-o>:echoh HintHL<Bar>echo "dbminit (name)"<Bar>echoh None<cr>
inorea dbm_nextkey	dbm_nextkey<c-o>:echoh HintHL<Bar>echo "dbm_nextkey (file)"<Bar>echoh None<cr>
inorea dbm_open	dbm_open<c-o>:echoh HintHL<Bar>echo "*dbm_open (name, flags, mode)"<Bar>echoh None<cr>
inorea dbm_pagfno	dbm_pagfno<c-o>:echoh HintHL<Bar>echo "dbm_pagfno (file)"<Bar>echoh None<cr>
inorea dbm_rdonly	dbm_rdonly<c-o>:echoh HintHL<Bar>echo "dbm_rdonly (file)"<Bar>echoh None<cr>
inorea dbm_store	dbm_store<c-o>:echoh HintHL<Bar>echo "dbm_store (file, key, content, flags)"<Bar>echoh None<cr>
inorea defined	defined<c-o>:echoh HintHL<Bar>echo "#if !defined(PNG_1_0_X)"<Bar>echoh None<cr>
inorea def_prog_mode	def_prog_mode<c-o>:echoh HintHL<Bar>echo "int def_prog_mode(void)"<Bar>echoh None<cr>
inorea def_shell_mode	def_shell_mode<c-o>:echoh HintHL<Bar>echo "int def_shell_mode(void)"<Bar>echoh None<cr>
inorea delay_output	delay_output<c-o>:echoh HintHL<Bar>echo "int delay_output(int ms)"<Bar>echoh None<cr>
inorea delch	delch<c-o>:echoh HintHL<Bar>echo "int delch(void)"<Bar>echoh None<cr>
inorea del_curterm	del_curterm<c-o>:echoh HintHL<Bar>echo "int del_curterm(TERMINAL *oterm)"<Bar>echoh None<cr>
inorea delete	delete<c-o>:echoh HintHL<Bar>echo "delete (key)"<Bar>echoh None<cr>
inorea deleteln	deleteln<c-o>:echoh HintHL<Bar>echo "int deleteln(void)"<Bar>echoh None<cr>
inorea del_panel	del_panel<c-o>:echoh HintHL<Bar>echo "int del_panel(PANEL *pan)"<Bar>echoh None<cr>
inorea delscreen	delscreen<c-o>:echoh HintHL<Bar>echo "void delscreen(SCREEN* sp)"<Bar>echoh None<cr>
inorea delwin	delwin<c-o>:echoh HintHL<Bar>echo "int delwin(WINDOW *win)"<Bar>echoh None<cr>
inorea derwin	derwin<c-o>:echoh HintHL<Bar>echo "WINDOW *derwin(WINDOW *orig, int nlines, int ncols, int begin_y, int begin_x)"<Bar>echoh None<cr>
inorea DES_FAILED	DES_FAILED<c-o>:echoh HintHL<Bar>echo "int DES_FAILED(int status)"<Bar>echoh None<cr>
inorea des_setparity	des_setparity<c-o>:echoh HintHL<Bar>echo "void des_setparity(char * key)"<Bar>echoh None<cr>
inorea dev_lock	dev_lock<c-o>:echoh HintHL<Bar>echo "pid_t dev_lock( const char * devname)"<Bar>echoh None<cr>
inorea dev_relock	dev_relock<c-o>:echoh HintHL<Bar>echo "pid_t dev_relock( const char * devname, pid_t pid)"<Bar>echoh None<cr>
inorea dev_testlock	dev_testlock<c-o>:echoh HintHL<Bar>echo "pid_t dev_testlock( const char * devname)"<Bar>echoh None<cr>
inorea dev_unlock	dev_unlock<c-o>:echoh HintHL<Bar>echo "pid_t dev_unlock( const char * devname, pid_t pid)"<Bar>echoh None<cr>
inorea difftime	difftime<c-o>:echoh HintHL<Bar>echo "double difftime(time_t time1, time_t time0)"<Bar>echoh None<cr>
inorea dirfd	dirfd<c-o>:echoh HintHL<Bar>echo "int dirfd(DIR * dir)"<Bar>echoh None<cr>
inorea dirname	dirname<c-o>:echoh HintHL<Bar>echo "char *dirname(char * path)"<Bar>echoh None<cr>
inorea div	div<c-o>:echoh HintHL<Bar>echo "div_t div(int numerator, int denominator)"<Bar>echoh None<cr>
inorea dlclose	dlclose<c-o>:echoh HintHL<Bar>echo "int dlclose(void * handle)"<Bar>echoh None<cr>
inorea dlerror	dlerror<c-o>:echoh HintHL<Bar>echo "char *dlerror(void)"<Bar>echoh None<cr>
inorea dlopen	dlopen<c-o>:echoh HintHL<Bar>echo "void *dlopen(const char * filename, int flag)"<Bar>echoh None<cr>
inorea dlsym	dlsym<c-o>:echoh HintHL<Bar>echo "void *dlsym(void * handle, const char * symbol)"<Bar>echoh None<cr>
inorea dn_comp	dn_comp<c-o>:echoh HintHL<Bar>echo "int dn_comp(unsigned char * exp_dn, unsigned char * comp_dn, int length, unsigned char ** dnptrs, unsigned char * exp_dn, unsigned char ** lastdnptr)"<Bar>echoh None<cr>
inorea dn_expand	dn_expand<c-o>:echoh HintHL<Bar>echo "int dn_expand(unsigned char * msg, unsigned char * eomorig, unsigned char * comp_dn, unsigned char * exp_dn, int length)"<Bar>echoh None<cr>
inorea doupdate	doupdate<c-o>:echoh HintHL<Bar>echo "int doupdate(void)"<Bar>echoh None<cr>
inorea DPMSCapable	DPMSCapable<c-o>:echoh HintHL<Bar>echo "Bool DPMSCapable ( Display *display\fP\^)"<Bar>echoh None<cr>
inorea DPMSDisable	DPMSDisable<c-o>:echoh HintHL<Bar>echo "Status DPMSDisable ( Display *display\fP\^)"<Bar>echoh None<cr>
inorea DPMSEnable	DPMSEnable<c-o>:echoh HintHL<Bar>echo "Status DPMSEnable ( Display *display\fP\^)"<Bar>echoh None<cr>
inorea DPMSForceLevel	DPMSForceLevel<c-o>:echoh HintHL<Bar>echo "Status DPMSForceLevel ( Display *display\fP\^, CARD16 level\fP\^)"<Bar>echoh None<cr>
inorea dprintf	dprintf<c-o>:echoh HintHL<Bar>echo "int dprintf(int fd, const char * format, ...)"<Bar>echoh None<cr>
inorea drand48	drand48<c-o>:echoh HintHL<Bar>echo "double drand48(void)"<Bar>echoh None<cr>
inorea drand48_r	drand48_r<c-o>:echoh HintHL<Bar>echo "int drand48_r(struct drand48_data * buffer, double * result)"<Bar>echoh None<cr>
inorea drem	drem<c-o>:echoh HintHL<Bar>echo "double drem(double x, double y)"<Bar>echoh None<cr>
inorea dremf	dremf<c-o>:echoh HintHL<Bar>echo "float dremf(float x, float y)"<Bar>echoh None<cr>
inorea dreml	dreml<c-o>:echoh HintHL<Bar>echo "long double dreml(long double x, long double y)"<Bar>echoh None<cr>
inorea dup_field	dup_field<c-o>:echoh HintHL<Bar>echo "FIELD *dup_field(FIELD *field, int toprow, int leftcol)"<Bar>echoh None<cr>
inorea dupwin	dupwin<c-o>:echoh HintHL<Bar>echo "WINDOW *dupwin(WINDOW *win)"<Bar>echoh None<cr>
inorea dynamic_field_info	dynamic_field_info<c-o>:echoh HintHL<Bar>echo "int dynamic_field_info(const FIELD *field, int *rows, int *cols, int *max)"<Bar>echoh None<cr>
inorea dysize	dysize<c-o>:echoh HintHL<Bar>echo "int dysize(int year)"<Bar>echoh None<cr>
inorea ecb_crypt	ecb_crypt<c-o>:echoh HintHL<Bar>echo "int ecb_crypt(char * key, char * data, unsigned datalen, unsigned mode)"<Bar>echoh None<cr>
inorea echochar	echochar<c-o>:echoh HintHL<Bar>echo "int echochar(const chtype ch)"<Bar>echoh None<cr>
inorea echo	echo<c-o>:echoh HintHL<Bar>echo "int echo(void)"<Bar>echoh None<cr>
inorea echo_wchar	echo_wchar<c-o>:echoh HintHL<Bar>echo "int echo_wchar( const cchar_t *wch)"<Bar>echoh None<cr>
inorea ecvt	ecvt<c-o>:echoh HintHL<Bar>echo "char *ecvt(double number, int ndigits, int * decpt, int * sign)"<Bar>echoh None<cr>
inorea ecvt_r	ecvt_r<c-o>:echoh HintHL<Bar>echo "int ecvt_r(double number, int ndigits, int * decpt, int * sign, char * buf, size_t len)"<Bar>echoh None<cr>
inorea encrypt	encrypt<c-o>:echoh HintHL<Bar>echo "void encrypt(char block [64], int edflag)"<Bar>echoh None<cr>
inorea encrypt_r	encrypt_r<c-o>:echoh HintHL<Bar>echo "void encrypt_r (char * block, int edflag, struct crypt_data * data)"<Bar>echoh None<cr>
inorea endaliasent	endaliasent<c-o>:echoh HintHL<Bar>echo "void endaliasent(void)"<Bar>echoh None<cr>
inorea endfsent	endfsent<c-o>:echoh HintHL<Bar>echo "void endfsent(void)"<Bar>echoh None<cr>
inorea endgrent	endgrent<c-o>:echoh HintHL<Bar>echo "void endgrent(void)"<Bar>echoh None<cr>
inorea endhostent	endhostent<c-o>:echoh HintHL<Bar>echo "void endhostent(void)"<Bar>echoh None<cr>
inorea endmntent	endmntent<c-o>:echoh HintHL<Bar>echo "int endmntent(FILE * fp)"<Bar>echoh None<cr>
inorea endnetent	endnetent<c-o>:echoh HintHL<Bar>echo "void endnetent(void)"<Bar>echoh None<cr>
inorea endprotoent	endprotoent<c-o>:echoh HintHL<Bar>echo "void endprotoent(void)"<Bar>echoh None<cr>
inorea endpwent	endpwent<c-o>:echoh HintHL<Bar>echo "void endpwent(void)"<Bar>echoh None<cr>
inorea endrpcent	endrpcent<c-o>:echoh HintHL<Bar>echo "endrpcent ()"<Bar>echoh None<cr>
inorea endservent	endservent<c-o>:echoh HintHL<Bar>echo "void endservent(void)"<Bar>echoh None<cr>
inorea endttyent	endttyent<c-o>:echoh HintHL<Bar>echo "int endttyent(void)"<Bar>echoh None<cr>
inorea endusershell	endusershell<c-o>:echoh HintHL<Bar>echo "void endusershell(void)"<Bar>echoh None<cr>
inorea endutent	endutent<c-o>:echoh HintHL<Bar>echo "void endutent(void)"<Bar>echoh None<cr>
inorea endwin	endwin<c-o>:echoh HintHL<Bar>echo "int endwin(void)"<Bar>echoh None<cr>
inorea envz_entry	envz_entry<c-o>:echoh HintHL<Bar>echo "envz_entry(const char * envz, size_t * envz_len, const char * name)"<Bar>echoh None<cr>
inorea envz_get	envz_get<c-o>:echoh HintHL<Bar>echo "envz_get(const char * envz, size_t * envz_len, const char * name)"<Bar>echoh None<cr>
inorea envz_remove	envz_remove<c-o>:echoh HintHL<Bar>echo "envz_remove(char ** envz, size_t * envz_len, const char * name)"<Bar>echoh None<cr>
inorea envz_strip	envz_strip<c-o>:echoh HintHL<Bar>echo "envz_strip(char ** envz, size_t * envz_len)"<Bar>echoh None<cr>
inorea erand48	erand48<c-o>:echoh HintHL<Bar>echo "double erand48(unsigned short xsubi [3])"<Bar>echoh None<cr>
inorea erand48_r	erand48_r<c-o>:echoh HintHL<Bar>echo "int erand48_r(unsigned short xsubi [3], struct drand48_data *buffer, double * result)"<Bar>echoh None<cr>
inorea erasechar	erasechar<c-o>:echoh HintHL<Bar>echo "char erasechar(void)"<Bar>echoh None<cr>
inorea erase	erase<c-o>:echoh HintHL<Bar>echo "int erase(void)"<Bar>echoh None<cr>
inorea erasewchar	erasewchar<c-o>:echoh HintHL<Bar>echo "int erasewchar(wchar_t *ch)"<Bar>echoh None<cr>
inorea erfc	erfc<c-o>:echoh HintHL<Bar>echo "double erfc(double x)"<Bar>echoh None<cr>
inorea erfcf	erfcf<c-o>:echoh HintHL<Bar>echo "float erfcf(float x)"<Bar>echoh None<cr>
inorea erfcl	erfcl<c-o>:echoh HintHL<Bar>echo "long double erfcl(long double x)"<Bar>echoh None<cr>
inorea erf	erf<c-o>:echoh HintHL<Bar>echo "double erf(double x)"<Bar>echoh None<cr>
inorea erff	erff<c-o>:echoh HintHL<Bar>echo "float erff(float x)"<Bar>echoh None<cr>
inorea erfl	erfl<c-o>:echoh HintHL<Bar>echo "long double erfl(long double x)"<Bar>echoh None<cr>
inorea ether_aton	ether_aton<c-o>:echoh HintHL<Bar>echo "ether_aton(const char * asc)"<Bar>echoh None<cr>
inorea ether_aton_r	ether_aton_r<c-o>:echoh HintHL<Bar>echo "ether_aton_r(const char * asc, struct ether_addr * addr)"<Bar>echoh None<cr>
inorea ether_hostton	ether_hostton<c-o>:echoh HintHL<Bar>echo "ether_hostton(const char * hostname, struct ether_addr * addr)"<Bar>echoh None<cr>
inorea ether_line	ether_line<c-o>:echoh HintHL<Bar>echo "ether_line(const char * line, struct ether_addr * addr, char * hostname)"<Bar>echoh None<cr>
inorea ether_ntoa	ether_ntoa<c-o>:echoh HintHL<Bar>echo "ether_ntoa(const struct ether_addr * addr)"<Bar>echoh None<cr>
inorea ether_ntoa_r	ether_ntoa_r<c-o>:echoh HintHL<Bar>echo "ether_ntoa_r(const struct ether_addr * addr, char * buf)"<Bar>echoh None<cr>
inorea ether_ntohost	ether_ntohost<c-o>:echoh HintHL<Bar>echo "ether_ntohost(char * hostname, const struct ether_addr * addr)"<Bar>echoh None<cr>
inorea execl	execl<c-o>:echoh HintHL<Bar>echo "int execl(const char * path, const char * arg, ...)"<Bar>echoh None<cr>
inorea execlp	execlp<c-o>:echoh HintHL<Bar>echo "int execlp(const char * file, const char * arg, ...)"<Bar>echoh None<cr>
inorea execv	execv<c-o>:echoh HintHL<Bar>echo "int execv(const char * path, char *const argv [])"<Bar>echoh None<cr>
inorea execvp	execvp<c-o>:echoh HintHL<Bar>echo "int execvp(const char * file, char *const argv [])"<Bar>echoh None<cr>
inorea exit	exit<c-o>:echoh HintHL<Bar>echo "void exit(int status)"<Bar>echoh None<cr>
inorea exp10	exp10<c-o>:echoh HintHL<Bar>echo "double exp10(double x)"<Bar>echoh None<cr>
inorea exp10f	exp10f<c-o>:echoh HintHL<Bar>echo "float exp10f(float x)"<Bar>echoh None<cr>
inorea exp10l	exp10l<c-o>:echoh HintHL<Bar>echo "long double exp10l(long double x)"<Bar>echoh None<cr>
inorea exp2	exp2<c-o>:echoh HintHL<Bar>echo "double exp2(double x)"<Bar>echoh None<cr>
inorea exp2f	exp2f<c-o>:echoh HintHL<Bar>echo "float exp2f(float x)"<Bar>echoh None<cr>
inorea exp2l	exp2l<c-o>:echoh HintHL<Bar>echo "long double exp2l(long double x)"<Bar>echoh None<cr>
inorea exp	exp<c-o>:echoh HintHL<Bar>echo "double exp(double x)"<Bar>echoh None<cr>
inorea expf	expf<c-o>:echoh HintHL<Bar>echo "float expf(float x)"<Bar>echoh None<cr>
inorea expl	expl<c-o>:echoh HintHL<Bar>echo "long double expl(long double x)"<Bar>echoh None<cr>
inorea expm1	expm1<c-o>:echoh HintHL<Bar>echo "double expm1(double x)"<Bar>echoh None<cr>
inorea expm1f	expm1f<c-o>:echoh HintHL<Bar>echo "float expm1f(float x)"<Bar>echoh None<cr>
inorea expm1l	expm1l<c-o>:echoh HintHL<Bar>echo "long double expm1l(long double x)"<Bar>echoh None<cr>
inorea exsltCommonRegister	exsltCommonRegister<c-o>:echoh HintHL<Bar>echo "void exsltCommonRegister(void)"<Bar>echoh None<cr>
inorea exsltDateRegister	exsltDateRegister<c-o>:echoh HintHL<Bar>echo "void exsltDateRegister(void)"<Bar>echoh None<cr>
inorea exsltDynRegister	exsltDynRegister<c-o>:echoh HintHL<Bar>echo "void exsltDynRegister(void)"<Bar>echoh None<cr>
inorea exsltFuncRegister	exsltFuncRegister<c-o>:echoh HintHL<Bar>echo "void exsltFuncRegister(void)"<Bar>echoh None<cr>
inorea exsltMathRegister	exsltMathRegister<c-o>:echoh HintHL<Bar>echo "void exsltMathRegister(void)"<Bar>echoh None<cr>
inorea exsltRegisterAll	exsltRegisterAll<c-o>:echoh HintHL<Bar>echo "void exsltRegisterAll(void)"<Bar>echoh None<cr>
inorea exsltSaxonRegister	exsltSaxonRegister<c-o>:echoh HintHL<Bar>echo "void exsltSaxonRegister(void)"<Bar>echoh None<cr>
inorea exsltSetsRegister	exsltSetsRegister<c-o>:echoh HintHL<Bar>echo "void exsltSetsRegister(void)"<Bar>echoh None<cr>
inorea exsltStrRegister	exsltStrRegister<c-o>:echoh HintHL<Bar>echo "void exsltStrRegister(void)"<Bar>echoh None<cr>
inorea extracted	extracted<c-o>:echoh HintHL<Bar>echo "parameter then these sections are extracted (see Pod::Select)"<Bar>echoh None<cr>
inorea fabs	fabs<c-o>:echoh HintHL<Bar>echo "double fabs(double x)"<Bar>echoh None<cr>
inorea fabsf	fabsf<c-o>:echoh HintHL<Bar>echo "float fabsf(float x)"<Bar>echoh None<cr>
inorea fabsl	fabsl<c-o>:echoh HintHL<Bar>echo "long double fabsl(long double x)"<Bar>echoh None<cr>
inorea __fbufsize	__fbufsize<c-o>:echoh HintHL<Bar>echo "size_t __fbufsize(FILE * stream)"<Bar>echoh None<cr>
inorea FcAtomicCreate	FcAtomicCreate<c-o>:echoh HintHL<Bar>echo "FcAtomic * FcAtomicCreate (const FcChar8 *file)"<Bar>echoh None<cr>
inorea FcAtomicDeleteNew	FcAtomicDeleteNew<c-o>:echoh HintHL<Bar>echo "void FcAtomicDeleteNew (FcAtomic *atomic)"<Bar>echoh None<cr>
inorea FcAtomicDestroy	FcAtomicDestroy<c-o>:echoh HintHL<Bar>echo "void FcAtomicDestroy (FcAtomic *atomic)"<Bar>echoh None<cr>
inorea FcAtomicLock	FcAtomicLock<c-o>:echoh HintHL<Bar>echo "FcBool FcAtomicLock (FcAtomic *atomic)"<Bar>echoh None<cr>
inorea FcAtomicNewFile	FcAtomicNewFile<c-o>:echoh HintHL<Bar>echo "FcChar8 * FcAtomicNewFile (FcAtomic *atomic)"<Bar>echoh None<cr>
inorea FcAtomicOrigFile	FcAtomicOrigFile<c-o>:echoh HintHL<Bar>echo "FcChar8 * FcAtomicOrigFile (FcAtomic *atomic)"<Bar>echoh None<cr>
inorea FcAtomicReplaceOrig	FcAtomicReplaceOrig<c-o>:echoh HintHL<Bar>echo "FcBool FcAtomicReplaceOrig (FcAtomic *atomic)"<Bar>echoh None<cr>
inorea FcAtomicUnlock	FcAtomicUnlock<c-o>:echoh HintHL<Bar>echo "void FcAtomicUnlock (FcAtomic *atomic)"<Bar>echoh None<cr>
inorea FcBlanksAdd	FcBlanksAdd<c-o>:echoh HintHL<Bar>echo "FcBool FcBlanksAdd (FcBlanks *b, FcChar32ucs4)"<Bar>echoh None<cr>
inorea FcBlanksCreate	FcBlanksCreate<c-o>:echoh HintHL<Bar>echo "FcBlanks * FcBlanksCreate (void)"<Bar>echoh None<cr>
inorea FcBlanksDestroy	FcBlanksDestroy<c-o>:echoh HintHL<Bar>echo "void FcBlanksDestroy (FcBlanks *b)"<Bar>echoh None<cr>
inorea FcBlanksIsMember	FcBlanksIsMember<c-o>:echoh HintHL<Bar>echo "FcBool FcBlanksIsMember (FcBlanks *b, FcChar32ucs4)"<Bar>echoh None<cr>
inorea FcCharSetAddChar	FcCharSetAddChar<c-o>:echoh HintHL<Bar>echo "FcBool FcCharSetAddChar (FcCharSet *fcs, FcChar32ucs4)"<Bar>echoh None<cr>
inorea FcCharSetCopy	FcCharSetCopy<c-o>:echoh HintHL<Bar>echo "FcCharSet * FcCharSetCopy (FcCharSet *src)"<Bar>echoh None<cr>
inorea FcCharSetCount	FcCharSetCount<c-o>:echoh HintHL<Bar>echo "FcChar32 FcCharSetCount (const FcCharSet *a)"<Bar>echoh None<cr>
inorea FcCharSetCreate	FcCharSetCreate<c-o>:echoh HintHL<Bar>echo "FcCharSet * FcCharSetCreate (void)"<Bar>echoh None<cr>
inorea FcCharSetDestroy	FcCharSetDestroy<c-o>:echoh HintHL<Bar>echo "void FcCharSetDestroy (FcCharSet *fcs)"<Bar>echoh None<cr>
inorea FcCharSetEqual	FcCharSetEqual<c-o>:echoh HintHL<Bar>echo "FcBool FcCharSetEqual (const FcCharSet *a, const FcCharSet *b)"<Bar>echoh None<cr>
inorea FcCharSetFirstPage	FcCharSetFirstPage<c-o>:echoh HintHL<Bar>echo "FcChar32 FcCharSetFirstPage (const FcCharSet *a, FcChar32[FC_CHARSET_MAP_SIZE]map, FcChar32 *next)"<Bar>echoh None<cr>
inorea FcCharSetHasChar	FcCharSetHasChar<c-o>:echoh HintHL<Bar>echo "FcBool FcCharSetHasChar (const FcCharSet *fcs, FcChar32ucs4)"<Bar>echoh None<cr>
inorea FcCharSetIntersectCount	FcCharSetIntersectCount<c-o>:echoh HintHL<Bar>echo "FcChar32 FcCharSetIntersectCount (const FcCharSet *a, const FcCharSet *b)"<Bar>echoh None<cr>
inorea FcCharSetIntersect	FcCharSetIntersect<c-o>:echoh HintHL<Bar>echo "FcCharSet * FcCharSetIntersect (const FcCharSet *a, const FcCharSet *b)"<Bar>echoh None<cr>
inorea FcCharSetIsSubset	FcCharSetIsSubset<c-o>:echoh HintHL<Bar>echo "FcBool FcCharSetIsSubset (const FcCharSet *a, const FcCharSet *b)"<Bar>echoh None<cr>
inorea FcCharSetNextPage	FcCharSetNextPage<c-o>:echoh HintHL<Bar>echo "FcChar32 FcCharSetNextPage (const FcCharSet *a, FcChar32[FC_CHARSET_MAP_SIZE]map, FcChar32 *next)"<Bar>echoh None<cr>
inorea FcCharSetSubtractCount	FcCharSetSubtractCount<c-o>:echoh HintHL<Bar>echo "FcChar32 FcCharSetSubtractCount (const FcCharSet *a, const FcCharSet *b)"<Bar>echoh None<cr>
inorea FcCharSetSubtract	FcCharSetSubtract<c-o>:echoh HintHL<Bar>echo "FcCharSet * FcCharSetSubtract (const FcCharSet *a, const FcCharSet *b)"<Bar>echoh None<cr>
inorea FcCharSetUnion	FcCharSetUnion<c-o>:echoh HintHL<Bar>echo "FcCharSet * FcCharSetUnion (const FcCharSet *a, const FcCharSet *b)"<Bar>echoh None<cr>
inorea FcConfigAppFontAddDir	FcConfigAppFontAddDir<c-o>:echoh HintHL<Bar>echo "FcBool FcConfigAppFontAddDir (FcConfig *config, const char *)"<Bar>echoh None<cr>
inorea FcConfigAppFontAddFile	FcConfigAppFontAddFile<c-o>:echoh HintHL<Bar>echo "FcBool FcConfigAppFontAddFile (FcConfig *config, const char *file)"<Bar>echoh None<cr>
inorea FcConfigAppFontClear	FcConfigAppFontClear<c-o>:echoh HintHL<Bar>echo "void FcConfigAppFontClear (FcConfig *config)"<Bar>echoh None<cr>
inorea FcConfigBuildFonts	FcConfigBuildFonts<c-o>:echoh HintHL<Bar>echo "FcBool FcConfigBuildFonts (FcConfig *config)"<Bar>echoh None<cr>
inorea FcConfigCreate	FcConfigCreate<c-o>:echoh HintHL<Bar>echo "FcConfig * FcConfigCreate (void)"<Bar>echoh None<cr>
inorea FcConfigDestroy	FcConfigDestroy<c-o>:echoh HintHL<Bar>echo "void FcConfigDestroy (FcConfig *config)"<Bar>echoh None<cr>
inorea FcConfigFilename	FcConfigFilename<c-o>:echoh HintHL<Bar>echo "char * FcConfigFilename (const char *name)"<Bar>echoh None<cr>
inorea FcConfigGetBlanks	FcConfigGetBlanks<c-o>:echoh HintHL<Bar>echo "FcBlanks * FcConfigGetBlanks (FcConfig *config)"<Bar>echoh None<cr>
inorea FcConfigGetCache	FcConfigGetCache<c-o>:echoh HintHL<Bar>echo "char * FcConfigGetCache (FcConfig *config)"<Bar>echoh None<cr>
inorea FcConfigGetConfigDirs	FcConfigGetConfigDirs<c-o>:echoh HintHL<Bar>echo "FcStrList * FcConfigGetConfigDirs (FcConfig *config)"<Bar>echoh None<cr>
inorea FcConfigGetConfigFiles	FcConfigGetConfigFiles<c-o>:echoh HintHL<Bar>echo "FcStrList * FcConfigGetConfigFiles (FcConfig *config)"<Bar>echoh None<cr>
inorea FcConfigGetCurrent	FcConfigGetCurrent<c-o>:echoh HintHL<Bar>echo "FcConfig * FcConfigGetCurrent (void)"<Bar>echoh None<cr>
inorea FcConfigGetFontDirs	FcConfigGetFontDirs<c-o>:echoh HintHL<Bar>echo "FcStrList * FcConfigGetFontDirs (FcConfig *config)"<Bar>echoh None<cr>
inorea FcConfigGetFonts	FcConfigGetFonts<c-o>:echoh HintHL<Bar>echo "FcFontSet * FcConfigGetFonts (FcConfig *config, FcSetNameset)"<Bar>echoh None<cr>
inorea FcConfigGetRescanInverval	FcConfigGetRescanInverval<c-o>:echoh HintHL<Bar>echo "int FcConfigGetRescanInverval (FcConfig *config)"<Bar>echoh None<cr>
inorea FcConfigNormalizeFontDir	FcConfigNormalizeFontDir<c-o>:echoh HintHL<Bar>echo "const FcChar8 * FcConfigNormalizeFontDir (FcConfig *config, const FcChar8 *dir)"<Bar>echoh None<cr>
inorea FcConfigParseAndLoad	FcConfigParseAndLoad<c-o>:echoh HintHL<Bar>echo "FcBool FcConfigParseAndLoad (FcConfig *config, const FcChar8 *file)"<Bar>echoh None<cr>
inorea FcConfigSetCurrent	FcConfigSetCurrent<c-o>:echoh HintHL<Bar>echo "FcBool FcConfigSetCurrent (FcConfig *config)"<Bar>echoh None<cr>
inorea FcConfigSetRescanInverval	FcConfigSetRescanInverval<c-o>:echoh HintHL<Bar>echo "FcBool FcConfigSetRescanInverval (FcConfig *config, intrescanInterval)"<Bar>echoh None<cr>
inorea FcConfigSubstitute	FcConfigSubstitute<c-o>:echoh HintHL<Bar>echo "FcBool FcConfigSubstitute (FcConfig *config, FcPattern *p, FcMatchKindkind)"<Bar>echoh None<cr>
inorea FcConfigSubstituteWithPat	FcConfigSubstituteWithPat<c-o>:echoh HintHL<Bar>echo "FcBool FcConfigSubstituteWithPat (FcConfig *config, FcPattern *p, FcPattern *p_pat, FcMatchKindkind)"<Bar>echoh None<cr>
inorea FcConfigUptoDate	FcConfigUptoDate<c-o>:echoh HintHL<Bar>echo "FcBool FcConfigUptoDate (FcConfig *config)"<Bar>echoh None<cr>
inorea FcDefaultSubstitute	FcDefaultSubstitute<c-o>:echoh HintHL<Bar>echo "void FcDefaultSubstitute (FcPattern *pattern)"<Bar>echoh None<cr>
inorea FcDirCacheValid	FcDirCacheValid<c-o>:echoh HintHL<Bar>echo "FcBool FcDirCacheValid (const FcChar8 *cache_file)"<Bar>echoh None<cr>
inorea FcDirSave	FcDirSave<c-o>:echoh HintHL<Bar>echo "FcBool FcDirSave (FcFontSet *set, FcStrSet *dirs, const char *dir)"<Bar>echoh None<cr>
inorea FcDirScan	FcDirScan<c-o>:echoh HintHL<Bar>echo "FcBool FcDirScan (FcFontSet *set, FcStrSet *dirs, FcFileCache *cache, FcBlanks *blanks, const char *dir, FcBoolforce)"<Bar>echoh None<cr>
inorea FcFileScan	FcFileScan<c-o>:echoh HintHL<Bar>echo "FcBool FcFileScan (FcFontSet *set, FcStrSet *dirs, FcFileCache *cache, FcBlanks *blanks, const char *file, FcBoolforce)"<Bar>echoh None<cr>
inorea FcFini	FcFini<c-o>:echoh HintHL<Bar>echo "void FcFini (void)"<Bar>echoh None<cr>
inorea FcFontList	FcFontList<c-o>:echoh HintHL<Bar>echo "FcFontSet * FcFontList (FcConfig *config, FcPattern *p, FcObjectSet *os)"<Bar>echoh None<cr>
inorea FcFontMatch	FcFontMatch<c-o>:echoh HintHL<Bar>echo "FcPattern * FcFontMatch (FcConfig *config, FcPattern *p, FcResult *result)"<Bar>echoh None<cr>
inorea FcFontRenderPrepare	FcFontRenderPrepare<c-o>:echoh HintHL<Bar>echo "FcPattern * FcFontRenderPrepare (FcConfig *config, FcPattern *pat, FcPattern *font)"<Bar>echoh None<cr>
inorea FcFontSetAdd	FcFontSetAdd<c-o>:echoh HintHL<Bar>echo "FcBool FcFontSetAdd (FcFontSet *s, FcPattern *font)"<Bar>echoh None<cr>
inorea FcFontSetCreate	FcFontSetCreate<c-o>:echoh HintHL<Bar>echo "FcFontSet * FcFontSetCreate (void)"<Bar>echoh None<cr>
inorea FcFontSetDestroy	FcFontSetDestroy<c-o>:echoh HintHL<Bar>echo "void FcFontSetDestroy (FcFontSet *s)"<Bar>echoh None<cr>
inorea FcFontSort	FcFontSort<c-o>:echoh HintHL<Bar>echo "FcFontSet * FcFontSort (FcConfig *config, FcPattern *p, FcBooltrim, FcCharSet **csp, FcResult *result)"<Bar>echoh None<cr>
inorea FcFreeTypeCharIndex	FcFreeTypeCharIndex<c-o>:echoh HintHL<Bar>echo "FT_UInt FcFreeTypeCharIndex (FT_Faceface, FcChar32ucs4)"<Bar>echoh None<cr>
inorea FcFreeTypeCharSet	FcFreeTypeCharSet<c-o>:echoh HintHL<Bar>echo "FcCharSet * FcFreeTypeCharSet (FT_Faceface, FcBlanks *blanks)"<Bar>echoh None<cr>
inorea FcFreeTypeQuery	FcFreeTypeQuery<c-o>:echoh HintHL<Bar>echo "FcPattern * FcFreeTypeQuery (const char *file, intid, FcBlanks *blanks, int *count)"<Bar>echoh None<cr>
inorea FcGetVersion	FcGetVersion<c-o>:echoh HintHL<Bar>echo "int FcGetVersion (void)"<Bar>echoh None<cr>
inorea FcInitBringUptoDate	FcInitBringUptoDate<c-o>:echoh HintHL<Bar>echo "FcBool FcInitBringUptoDate (void)"<Bar>echoh None<cr>
inorea FcInit	FcInit<c-o>:echoh HintHL<Bar>echo "FcBool FcInit (void)"<Bar>echoh None<cr>
inorea FcInitLoadConfigAndFonts	FcInitLoadConfigAndFonts<c-o>:echoh HintHL<Bar>echo "FcConfig * FcInitLoadConfigAndFonts (void)"<Bar>echoh None<cr>
inorea FcInitLoadConfig	FcInitLoadConfig<c-o>:echoh HintHL<Bar>echo "FcConfig * FcInitLoadConfig (void)"<Bar>echoh None<cr>
inorea FcInitReinitialize	FcInitReinitialize<c-o>:echoh HintHL<Bar>echo "FcBool FcInitReinitialize (void)"<Bar>echoh None<cr>
inorea fcloseall	fcloseall<c-o>:echoh HintHL<Bar>echo "int fcloseall(void)"<Bar>echoh None<cr>
inorea fclose	fclose<c-o>:echoh HintHL<Bar>echo "fclose(myfile)"<Bar>echoh None<cr>
inorea fclose	fclose<c-o>:echoh HintHL<Bar>echo "int fclose(FILE * fp)"<Bar>echoh None<cr>
inorea FcMatrixCopy	FcMatrixCopy<c-o>:echoh HintHL<Bar>echo "void FcMatrixCopy (const FcMatrix *matrix)"<Bar>echoh None<cr>
inorea FcMatrixEqual	FcMatrixEqual<c-o>:echoh HintHL<Bar>echo "void FcMatrixEqual (const FcMatrix *matrix1, const FcMatrix *matrix2)"<Bar>echoh None<cr>
inorea FcMatrixInit	FcMatrixInit<c-o>:echoh HintHL<Bar>echo "void FcMatrixInit (FcMatrix *matrix)"<Bar>echoh None<cr>
inorea FcMatrixMultiply	FcMatrixMultiply<c-o>:echoh HintHL<Bar>echo "void FcMatrixMultiply (FcMatrix *result, const FcMatrix *matrix1, const FcMatrix *matrix2)"<Bar>echoh None<cr>
inorea FcMatrixRotate	FcMatrixRotate<c-o>:echoh HintHL<Bar>echo "void FcMatrixRotate (FcMatrix *matrix, doublecos, doublesin)"<Bar>echoh None<cr>
inorea FcMatrixScale	FcMatrixScale<c-o>:echoh HintHL<Bar>echo "void FcMatrixScale (FcMatrix *matrix, doublesx, doubledy)"<Bar>echoh None<cr>
inorea FcMatrixShear	FcMatrixShear<c-o>:echoh HintHL<Bar>echo "void FcMatrixShear (FcMatrix *matrix, doublesh, doublesv)"<Bar>echoh None<cr>
inorea FcNameConstant	FcNameConstant<c-o>:echoh HintHL<Bar>echo "FcBool FcNameConstant (FcChar8 *string, int *result)"<Bar>echoh None<cr>
inorea FcNameGetConstant	FcNameGetConstant<c-o>:echoh HintHL<Bar>echo "const FcConstant * FcNameGetConstant (FcChar8 *string)"<Bar>echoh None<cr>
inorea FcNameGetObjectType	FcNameGetObjectType<c-o>:echoh HintHL<Bar>echo "const FcObjectType * FcNameGetObjectType (const char *object)"<Bar>echoh None<cr>
inorea FcNameParse	FcNameParse<c-o>:echoh HintHL<Bar>echo "FcPattern * FcNameParse (const char *name)"<Bar>echoh None<cr>
inorea FcNameRegisterConstants	FcNameRegisterConstants<c-o>:echoh HintHL<Bar>echo "FcBool FcNameRegisterConstants (const FcConstant *consts, intnconsts)"<Bar>echoh None<cr>
inorea FcNameRegisterObjectTypes	FcNameRegisterObjectTypes<c-o>:echoh HintHL<Bar>echo "FcBool FcNameRegisterObjectTypes (const FcObjectType *types, intntype)"<Bar>echoh None<cr>
inorea FcNameUnparse	FcNameUnparse<c-o>:echoh HintHL<Bar>echo "FcChar8 * FcNameUnparse (FcPattern *pat)"<Bar>echoh None<cr>
inorea FcNameUnregisterConstants	FcNameUnregisterConstants<c-o>:echoh HintHL<Bar>echo "FcBool FcNameUnregisterConstants (const FcConstant *consts, intnconsts)"<Bar>echoh None<cr>
inorea FcNameUnregisterObjectTypes	FcNameUnregisterObjectTypes<c-o>:echoh HintHL<Bar>echo "FcBool FcNameUnregisterObjectTypes (const FcObjectType *types, intntype)"<Bar>echoh None<cr>
inorea FcObjectSetAdd	FcObjectSetAdd<c-o>:echoh HintHL<Bar>echo "FcBool FcObjectSetAdd (FcObjectSet *os, const char *object)"<Bar>echoh None<cr>
inorea FcObjectSetCreate	FcObjectSetCreate<c-o>:echoh HintHL<Bar>echo "FcObjectSet * FcObjectSetCreate (void)"<Bar>echoh None<cr>
inorea FcObjectSetDestroy	FcObjectSetDestroy<c-o>:echoh HintHL<Bar>echo "void FcObjectSetDestroy (FcObjectSet *os)"<Bar>echoh None<cr>
inorea FcObjectSetVaBuild	FcObjectSetVaBuild<c-o>:echoh HintHL<Bar>echo "FcObjectSet * FcObjectSetVaBuild (const char *first, va_listva)"<Bar>echoh None<cr>
inorea FcPatternAddBool	FcPatternAddBool<c-o>:echoh HintHL<Bar>echo "FcBool FcPatternAddBool (FcPattern *p, const char *object, FcBoolb)"<Bar>echoh None<cr>
inorea FcPatternAddCharSet	FcPatternAddCharSet<c-o>:echoh HintHL<Bar>echo "FcBool FcPatternAddCharSet (FcPattern *p, const char *object, const FcCharSet *c)"<Bar>echoh None<cr>
inorea FcPatternAddDouble	FcPatternAddDouble<c-o>:echoh HintHL<Bar>echo "FcBool FcPatternAddDouble (FcPattern *p, const char *object, doubled)"<Bar>echoh None<cr>
inorea FcPatternAdd	FcPatternAdd<c-o>:echoh HintHL<Bar>echo "FcBool FcPatternAdd (FcPattern *p, const char *object, FcValuevalue, FcBoolappend)"<Bar>echoh None<cr>
inorea FcPatternAddInteger	FcPatternAddInteger<c-o>:echoh HintHL<Bar>echo "FcBool FcPatternAddInteger (FcPattern *p, const char *object, inti)"<Bar>echoh None<cr>
inorea FcPatternAddMatrix	FcPatternAddMatrix<c-o>:echoh HintHL<Bar>echo "FcBool FcPatternAddMatrix (FcPattern *p, const char *object, const FcMatrix *m)"<Bar>echoh None<cr>
inorea FcPatternAddString	FcPatternAddString<c-o>:echoh HintHL<Bar>echo "FcBool FcPatternAddString (FcPattern *p, const char *object, const char *s)"<Bar>echoh None<cr>
inorea FcPatternAddWeak	FcPatternAddWeak<c-o>:echoh HintHL<Bar>echo "FcBool FcPatternAddWeak (FcPattern *p, const char *object, FcValuevalue, FcBoolappend)"<Bar>echoh None<cr>
inorea FcPatternCreate	FcPatternCreate<c-o>:echoh HintHL<Bar>echo "FcPattern * FcPatternCreate (void)"<Bar>echoh None<cr>
inorea FcPatternDel	FcPatternDel<c-o>:echoh HintHL<Bar>echo "FcBool FcPatternDel (FcPattern *p, const char *object)"<Bar>echoh None<cr>
inorea FcPatternDestroy	FcPatternDestroy<c-o>:echoh HintHL<Bar>echo "void FcPatternDestroy (FcPattern *p)"<Bar>echoh None<cr>
inorea FcPatternEqual	FcPatternEqual<c-o>:echoh HintHL<Bar>echo "FcBool FcPatternEqual (const FcPattern *pa, const FcPattern *pb)"<Bar>echoh None<cr>
inorea FcPatternEqualSubset	FcPatternEqualSubset<c-o>:echoh HintHL<Bar>echo "FcBool FcPatternEqualSubset (const FcPattern *pa, const FcPattern *pb, const FcObjectSet *os)"<Bar>echoh None<cr>
inorea FcPatternGetBool	FcPatternGetBool<c-o>:echoh HintHL<Bar>echo "FcResult FcPatternGetBool (FcPattern *p, const char *object, intn, FcBool *b)"<Bar>echoh None<cr>
inorea FcPatternGetCharSet	FcPatternGetCharSet<c-o>:echoh HintHL<Bar>echo "FcResult FcPatternGetCharSet (FcPattern *p, const char *object, intn, FcCharSet **c)"<Bar>echoh None<cr>
inorea FcPatternGetDouble	FcPatternGetDouble<c-o>:echoh HintHL<Bar>echo "FcResult FcPatternGetDouble (FcPattern *p, const char *object, intn, double *d)"<Bar>echoh None<cr>
inorea FcPatternGet	FcPatternGet<c-o>:echoh HintHL<Bar>echo "FcResult FcPatternGet (FcPattern *p, const char *object, intid, FcValue *v)"<Bar>echoh None<cr>
inorea FcPatternGetInteger	FcPatternGetInteger<c-o>:echoh HintHL<Bar>echo "FcResult FcPatternGetInteger (FcPattern *p, const char *object, intn, int *i)"<Bar>echoh None<cr>
inorea FcPatternGetMatrix	FcPatternGetMatrix<c-o>:echoh HintHL<Bar>echo "FcResult FcPatternGetMatrix (FcPattern *p, const char *object, intn, FcMatrix **s)"<Bar>echoh None<cr>
inorea FcPatternGetString	FcPatternGetString<c-o>:echoh HintHL<Bar>echo "FcResult FcPatternGetString (FcPattern *p, const char *object, intn, char **consts)"<Bar>echoh None<cr>
inorea FcPatternHash	FcPatternHash<c-o>:echoh HintHL<Bar>echo "FcChar32 FcPatternHash (const FcPattern *p)"<Bar>echoh None<cr>
inorea FcPatternPrint	FcPatternPrint<c-o>:echoh HintHL<Bar>echo "void FcPatternPrint (const FcPattern *p)"<Bar>echoh None<cr>
inorea FcPatternRemove	FcPatternRemove<c-o>:echoh HintHL<Bar>echo "FcBool FcPatternRemove (FcPattern *p, const char *object, intid)"<Bar>echoh None<cr>
inorea FcPatternVaBuild	FcPatternVaBuild<c-o>:echoh HintHL<Bar>echo "FcPattern * FcPatternVaBuild (FcPattern *orig, va_listva)"<Bar>echoh None<cr>
inorea FcStrBasename	FcStrBasename<c-o>:echoh HintHL<Bar>echo "FcChar8 * FcStrBasename (const FcChar8 *file)"<Bar>echoh None<cr>
inorea FcStrCmpIgnoreCase	FcStrCmpIgnoreCase<c-o>:echoh HintHL<Bar>echo "int FcStrCmpIgnoreCase (const FcChar8 *s1, const FcChar8 *s2)"<Bar>echoh None<cr>
inorea FcStrCopy	FcStrCopy<c-o>:echoh HintHL<Bar>echo "FcChar8 * FcStrCopy (const FcChar8 *s)"<Bar>echoh None<cr>
inorea FcStrCopyFilename	FcStrCopyFilename<c-o>:echoh HintHL<Bar>echo "FcChar8 * FcStrCopyFilename (const FcChar8 *s)"<Bar>echoh None<cr>
inorea FcStrDirname	FcStrDirname<c-o>:echoh HintHL<Bar>echo "FcChar8 * FcStrDirname (const FcChar8 *file)"<Bar>echoh None<cr>
inorea FcStrDowncase	FcStrDowncase<c-o>:echoh HintHL<Bar>echo "FcChar8 * FcStrDowncase (const FcChar8 *s)"<Bar>echoh None<cr>
inorea FcStrListCreate	FcStrListCreate<c-o>:echoh HintHL<Bar>echo "FcStrList * FcStrListCreate (FcStrSet *set)"<Bar>echoh None<cr>
inorea FcStrListDone	FcStrListDone<c-o>:echoh HintHL<Bar>echo "void FcStrListDone (FcStrList *list)"<Bar>echoh None<cr>
inorea FcStrListNext	FcStrListNext<c-o>:echoh HintHL<Bar>echo "FcChar8 * FcStrListNext (FcStrList *list)"<Bar>echoh None<cr>
inorea FcStrSetAdd	FcStrSetAdd<c-o>:echoh HintHL<Bar>echo "FcBool FcStrSetAdd (FcStrSet *set, const FcChar8 *s)"<Bar>echoh None<cr>
inorea FcStrSetAddFilename	FcStrSetAddFilename<c-o>:echoh HintHL<Bar>echo "FcBool FcStrSetAddFilename (FcStrSet *set, const FcChar8 *s)"<Bar>echoh None<cr>
inorea FcStrSetCreate	FcStrSetCreate<c-o>:echoh HintHL<Bar>echo "FcStrSet * FcStrSetCreate (void)"<Bar>echoh None<cr>
inorea FcStrSetDel	FcStrSetDel<c-o>:echoh HintHL<Bar>echo "FcBool FcStrSetDel (FcStrSet *set, const FcChar8 *s)"<Bar>echoh None<cr>
inorea FcStrSetDestroy	FcStrSetDestroy<c-o>:echoh HintHL<Bar>echo "void FcStrSetDestroy (FcStrSet *set)"<Bar>echoh None<cr>
inorea FcStrSetMember	FcStrSetMember<c-o>:echoh HintHL<Bar>echo "FcBool FcStrSetMember (FcStrSet *set, const FcChar8 *s)"<Bar>echoh None<cr>
inorea FcStrStr	FcStrStr<c-o>:echoh HintHL<Bar>echo "FcChar8 * FcStrStr (const char *s1, const char *s2)"<Bar>echoh None<cr>
inorea FcStrStrIgnoreCase	FcStrStrIgnoreCase<c-o>:echoh HintHL<Bar>echo "FcChar8 * FcStrStrIgnoreCase (const char *s1, const char *s2)"<Bar>echoh None<cr>
inorea FcUcs4ToUtf8	FcUcs4ToUtf8<c-o>:echoh HintHL<Bar>echo "int FcUcs4ToUtf8 (FcChar32src, FcChar8dst[FC_UTF8_MAX_LEN])"<Bar>echoh None<cr>
inorea FcUtf16Len	FcUtf16Len<c-o>:echoh HintHL<Bar>echo "FcBool FcUtf16Len (FcChar8 *src, FcEndianendian, intlen, int *nchar, int *wchar)"<Bar>echoh None<cr>
inorea FcUtf16ToUcs4	FcUtf16ToUcs4<c-o>:echoh HintHL<Bar>echo "int FcUtf16ToUcs4 (FcChar8 *src, FcEndianendian, FcChar32 *dst, intlen)"<Bar>echoh None<cr>
inorea FcUtf8Len	FcUtf8Len<c-o>:echoh HintHL<Bar>echo "FcBool FcUtf8Len (FcChar8 *src, intlen, int *nchar, int *wchar)"<Bar>echoh None<cr>
inorea FcUtf8ToUcs4	FcUtf8ToUcs4<c-o>:echoh HintHL<Bar>echo "int FcUtf8ToUcs4 (FcChar8 *src, FcChar32 *dst, intlen)"<Bar>echoh None<cr>
inorea FcValueDestroy	FcValueDestroy<c-o>:echoh HintHL<Bar>echo "void FcValueDestroy (FcValuev)"<Bar>echoh None<cr>
inorea FcValueSave	FcValueSave<c-o>:echoh HintHL<Bar>echo "FcValue FcValueSave (FcValuev)"<Bar>echoh None<cr>
inorea fcvt	fcvt<c-o>:echoh HintHL<Bar>echo "char *fcvt(double number, int ndigits, int * decpt, int * sign)"<Bar>echoh None<cr>
inorea fcvt_r	fcvt_r<c-o>:echoh HintHL<Bar>echo "int fcvt_r(double number, int ndigits, int * decpt, int * sign, char * buf, size_t len)"<Bar>echoh None<cr>
inorea fdim	fdim<c-o>:echoh HintHL<Bar>echo "double fdim(double x, double y)"<Bar>echoh None<cr>
inorea fdimf	fdimf<c-o>:echoh HintHL<Bar>echo "float fdimf(float x, float y)"<Bar>echoh None<cr>
inorea fdiml	fdiml<c-o>:echoh HintHL<Bar>echo "long double fdiml(long double x, long double y)"<Bar>echoh None<cr>
inorea fdopen	fdopen<c-o>:echoh HintHL<Bar>echo "FILE *fdopen(int fildes, const char * mode)"<Bar>echoh None<cr>
inorea feclearexcept	feclearexcept<c-o>:echoh HintHL<Bar>echo "int feclearexcept(int excepts)"<Bar>echoh None<cr>
inorea fegetenv	fegetenv<c-o>:echoh HintHL<Bar>echo "int fegetenv(fenv_t * envp)"<Bar>echoh None<cr>
inorea fegetexceptflag	fegetexceptflag<c-o>:echoh HintHL<Bar>echo "int fegetexceptflag(fexcept_t * flagp, int excepts)"<Bar>echoh None<cr>
inorea fegetround	fegetround<c-o>:echoh HintHL<Bar>echo "int fegetround(void)"<Bar>echoh None<cr>
inorea feholdexcept	feholdexcept<c-o>:echoh HintHL<Bar>echo "int feholdexcept(fenv_t * envp)"<Bar>echoh None<cr>
inorea feof	feof<c-o>:echoh HintHL<Bar>echo "int feof(FILE * stream)"<Bar>echoh None<cr>
inorea feof_unlocked	feof_unlocked<c-o>:echoh HintHL<Bar>echo "int feof_unlocked(FILE * stream)"<Bar>echoh None<cr>
inorea feraiseexcept	feraiseexcept<c-o>:echoh HintHL<Bar>echo "int feraiseexcept(int excepts)"<Bar>echoh None<cr>
inorea ferror	ferror<c-o>:echoh HintHL<Bar>echo "int ferror(FILE * stream)"<Bar>echoh None<cr>
inorea ferror_unlocked	ferror_unlocked<c-o>:echoh HintHL<Bar>echo "int ferror_unlocked(FILE * stream)"<Bar>echoh None<cr>
inorea fesetenv	fesetenv<c-o>:echoh HintHL<Bar>echo "int fesetenv(const fenv_t * envp)"<Bar>echoh None<cr>
inorea fesetexceptflag	fesetexceptflag<c-o>:echoh HintHL<Bar>echo "int fesetexceptflag(const fexcept_t * flagp, int excepts)"<Bar>echoh None<cr>
inorea fesetround	fesetround<c-o>:echoh HintHL<Bar>echo "int fesetround(int rounding_mode)"<Bar>echoh None<cr>
inorea fetch	fetch<c-o>:echoh HintHL<Bar>echo "fetch (key)"<Bar>echoh None<cr>
inorea fetestexcept	fetestexcept<c-o>:echoh HintHL<Bar>echo "int fetestexcept(int excepts)"<Bar>echoh None<cr>
inorea feupdateenv	feupdateenv<c-o>:echoh HintHL<Bar>echo "int feupdateenv(const fenv_t * envp)"<Bar>echoh None<cr>
inorea f	f<c-o>:echoh HintHL<Bar>echo "something less obvious like \f(CW\*(C`use I18N::LangTags qw(/./)\*(C'.)"<Bar>echoh None<cr>
inorea fflush	fflush<c-o>:echoh HintHL<Bar>echo "int fflush(FILE * stream)"<Bar>echoh None<cr>
inorea fflush_unlocked	fflush_unlocked<c-o>:echoh HintHL<Bar>echo "int fflush_unlocked(FILE * stream)"<Bar>echoh None<cr>
inorea ffs	ffs<c-o>:echoh HintHL<Bar>echo "int ffs(int i)"<Bar>echoh None<cr>
inorea ffsl	ffsl<c-o>:echoh HintHL<Bar>echo "int ffsl(long int i)"<Bar>echoh None<cr>
inorea ffsll	ffsll<c-o>:echoh HintHL<Bar>echo "int ffsll(long long int i)"<Bar>echoh None<cr>
inorea fgetc	fgetc<c-o>:echoh HintHL<Bar>echo "int fgetc(FILE * stream)"<Bar>echoh None<cr>
inorea fgetc_unlocked	fgetc_unlocked<c-o>:echoh HintHL<Bar>echo "int fgetc_unlocked(FILE * stream)"<Bar>echoh None<cr>
inorea fgetfilecon	fgetfilecon<c-o>:echoh HintHL<Bar>echo "int fgetfilecon(int fd, security_context_t * con)"<Bar>echoh None<cr>
inorea fgetgrent	fgetgrent<c-o>:echoh HintHL<Bar>echo "struct group *fgetgrent(FILE * stream)"<Bar>echoh None<cr>
inorea fgetgrent_r	fgetgrent_r<c-o>:echoh HintHL<Bar>echo "int fgetgrent_r(FILE * fp, struct group * gbuf, char * buf, size_t buflen, struct group ** gbufp)"<Bar>echoh None<cr>
inorea fgetpos	fgetpos<c-o>:echoh HintHL<Bar>echo "int fgetpos(FILE * stream, fpos_t * pos)"<Bar>echoh None<cr>
inorea fgetpwent	fgetpwent<c-o>:echoh HintHL<Bar>echo "struct passwd *fgetpwent(FILE * stream)"<Bar>echoh None<cr>
inorea fgetpwent_r	fgetpwent_r<c-o>:echoh HintHL<Bar>echo "int fgetpwent_r(FILE * fp, struct passwd * pwbuf, char * buf, size_t buflen, struct passwd ** pwbufp)"<Bar>echoh None<cr>
inorea fgets	fgets<c-o>:echoh HintHL<Bar>echo "char *fgets(char * s, int size, FILE * stream)"<Bar>echoh None<cr>
inorea fgets_unlocked	fgets_unlocked<c-o>:echoh HintHL<Bar>echo "char *fgets_unlocked(char * s, int n, FILE * stream)"<Bar>echoh None<cr>
inorea fgetwc	fgetwc<c-o>:echoh HintHL<Bar>echo "wint_t fgetwc(FILE * stream)"<Bar>echoh None<cr>
inorea fgetwc_unlocked	fgetwc_unlocked<c-o>:echoh HintHL<Bar>echo "wint_t fgetwc_unlocked(FILE * stream)"<Bar>echoh None<cr>
inorea fgetws	fgetws<c-o>:echoh HintHL<Bar>echo "wchar_t *fgetws(wchar_t * ws, int n, FILE * stream)"<Bar>echoh None<cr>
inorea fgetws_unlocked	fgetws_unlocked<c-o>:echoh HintHL<Bar>echo "wchar_t *fgetws_unlocked(wchar_t * ws, int n, FILE * stream)"<Bar>echoh None<cr>
inorea field_arg	field_arg<c-o>:echoh HintHL<Bar>echo "void *field_arg(const FIELD *field)"<Bar>echoh None<cr>
inorea field_back	field_back<c-o>:echoh HintHL<Bar>echo "chtype field_back(const FIELD *field)"<Bar>echoh None<cr>
inorea field_buffer	field_buffer<c-o>:echoh HintHL<Bar>echo "char *field_buffer(const FIELD *field, int buffer)"<Bar>echoh None<cr>
inorea field_count	field_count<c-o>:echoh HintHL<Bar>echo "int field_count(const FORM *form)"<Bar>echoh None<cr>
inorea field_fore	field_fore<c-o>:echoh HintHL<Bar>echo "chtype field_fore(const FIELD *field)"<Bar>echoh None<cr>
inorea field_index	field_index<c-o>:echoh HintHL<Bar>echo "int field_index(const FIELD *field)"<Bar>echoh None<cr>
inorea field_info	field_info<c-o>:echoh HintHL<Bar>echo "int field_info(const FIELD *field, int *rows, int *cols, int *frow, int *fcol, int *nrow, int *nbuf)"<Bar>echoh None<cr>
inorea field_just	field_just<c-o>:echoh HintHL<Bar>echo "int field_just(const FIELD *field)"<Bar>echoh None<cr>
inorea field_opts	field_opts<c-o>:echoh HintHL<Bar>echo "OPTIONS field_opts(const FIELD *field)"<Bar>echoh None<cr>
inorea field_opts_off	field_opts_off<c-o>:echoh HintHL<Bar>echo "int field_opts_off(FIELD *field, OPTIONS opts)"<Bar>echoh None<cr>
inorea field_opts_on	field_opts_on<c-o>:echoh HintHL<Bar>echo "int field_opts_on(FIELD *field, OPTIONS opts)"<Bar>echoh None<cr>
inorea field_pad	field_pad<c-o>:echoh HintHL<Bar>echo "int field_pad(const FIELD *field)"<Bar>echoh None<cr>
inorea field_status	field_status<c-o>:echoh HintHL<Bar>echo "bool field_status(const FIELD *field)"<Bar>echoh None<cr>
inorea field_type	field_type<c-o>:echoh HintHL<Bar>echo "FIELDTYPE *field_type(const FIELD *field)"<Bar>echoh None<cr>
inorea field_userptr	field_userptr<c-o>:echoh HintHL<Bar>echo "void *field_userptr(const FIELD *field)"<Bar>echoh None<cr>
inorea fileno	fileno<c-o>:echoh HintHL<Bar>echo "int fileno(FILE * stream)"<Bar>echoh None<cr>
inorea fileno_unlocked	fileno_unlocked<c-o>:echoh HintHL<Bar>echo "int fileno_unlocked(FILE * stream)"<Bar>echoh None<cr>
inorea filter	filter<c-o>:echoh HintHL<Bar>echo "void filter(void)"<Bar>echoh None<cr>
inorea finitef	finitef<c-o>:echoh HintHL<Bar>echo "int finitef(float x)"<Bar>echoh None<cr>
inorea finite	finite<c-o>:echoh HintHL<Bar>echo "int finite(double x)"<Bar>echoh None<cr>
inorea finitel	finitel<c-o>:echoh HintHL<Bar>echo "int finitel(long double x)"<Bar>echoh None<cr>
inorea firstkey	firstkey<c-o>:echoh HintHL<Bar>echo "firstkey ()"<Bar>echoh None<cr>
inorea flash	flash<c-o>:echoh HintHL<Bar>echo "int flash(void)"<Bar>echoh None<cr>
inorea __flbf	__flbf<c-o>:echoh HintHL<Bar>echo "int __flbf(FILE * stream)"<Bar>echoh None<cr>
inorea flockfile	flockfile<c-o>:echoh HintHL<Bar>echo "void flockfile(FILE * filehandle)"<Bar>echoh None<cr>
inorea floorf	floorf<c-o>:echoh HintHL<Bar>echo "float floorf(float x)"<Bar>echoh None<cr>
inorea floor	floor<c-o>:echoh HintHL<Bar>echo "double floor(double x)"<Bar>echoh None<cr>
inorea floorl	floorl<c-o>:echoh HintHL<Bar>echo "long double floorl(long double x)"<Bar>echoh None<cr>
inorea flushinp	flushinp<c-o>:echoh HintHL<Bar>echo "int flushinp(void)"<Bar>echoh None<cr>
inorea _flushlbf	_flushlbf<c-o>:echoh HintHL<Bar>echo "void _flushlbf(void)"<Bar>echoh None<cr>
inorea fmaf	fmaf<c-o>:echoh HintHL<Bar>echo "float fmaf(float x, float y, float z)"<Bar>echoh None<cr>
inorea fma	fma<c-o>:echoh HintHL<Bar>echo "double fma(double x, double y, double z)"<Bar>echoh None<cr>
inorea fmal	fmal<c-o>:echoh HintHL<Bar>echo "long double fmal(long double x, long double y, long double z)"<Bar>echoh None<cr>
inorea fmaxf	fmaxf<c-o>:echoh HintHL<Bar>echo "float fmaxf(float x, float y)"<Bar>echoh None<cr>
inorea fmax	fmax<c-o>:echoh HintHL<Bar>echo "double fmax(double x, double y)"<Bar>echoh None<cr>
inorea fmaxl	fmaxl<c-o>:echoh HintHL<Bar>echo "long double fmaxl(long double x, long double y)"<Bar>echoh None<cr>
inorea fmemopen	fmemopen<c-o>:echoh HintHL<Bar>echo "FILE *fmemopen (void *buf, size_t size, const char * mode)"<Bar>echoh None<cr>
inorea fminf	fminf<c-o>:echoh HintHL<Bar>echo "float fminf(float x, float y)"<Bar>echoh None<cr>
inorea fmin	fmin<c-o>:echoh HintHL<Bar>echo "double fmin(double x, double y)"<Bar>echoh None<cr>
inorea fminl	fminl<c-o>:echoh HintHL<Bar>echo "long double fminl(long double x, long double y)"<Bar>echoh None<cr>
inorea fmodf	fmodf<c-o>:echoh HintHL<Bar>echo "float fmodf(float x, float y)"<Bar>echoh None<cr>
inorea fmod	fmod<c-o>:echoh HintHL<Bar>echo "double fmod(double x, double y)"<Bar>echoh None<cr>
inorea fmodl	fmodl<c-o>:echoh HintHL<Bar>echo "long double fmodl(long double x, long double y)"<Bar>echoh None<cr>
inorea fmtmsg	fmtmsg<c-o>:echoh HintHL<Bar>echo "int fmtmsg(long classification, const char * label, int severity, const char * text, const char * action, const char * tag)"<Bar>echoh None<cr>
inorea fnmatch	fnmatch<c-o>:echoh HintHL<Bar>echo "int fnmatch(const char * pattern, const char * string, int flags)"<Bar>echoh None<cr>
inorea FontCacheChangeCacheSettings	FontCacheChangeCacheSettings<c-o>:echoh HintHL<Bar>echo "Status FontCacheChangeCacheSettings(Display *dpy\fP, FontCacheSettings *cache info\fP)"<Bar>echoh None<cr>
inorea FontCacheGetCacheSettings	FontCacheGetCacheSettings<c-o>:echoh HintHL<Bar>echo "Status FontCacheGetCacheSettings(Display *dpy\fP, FontCacheSettings *cache info\fP)"<Bar>echoh None<cr>
inorea FontCacheGetCacheStatistics	FontCacheGetCacheStatistics<c-o>:echoh HintHL<Bar>echo "Status FontCacheGetCacheStatistics(Display *dpy\fP, FontCacheStatistics *cache statistics info\fP)"<Bar>echoh None<cr>
inorea FontCacheQueryExtension	FontCacheQueryExtension<c-o>:echoh HintHL<Bar>echo "Bool FontCacheQueryExtension(Display *dpy\fP, int *event_basep\fP, int *error_basep\fP\^)"<Bar>echoh None<cr>
inorea FontCacheQueryVersion	FontCacheQueryVersion<c-o>:echoh HintHL<Bar>echo "Status FontCacheQueryVersion(Display *dpy\fP, int *major_versionp\fP, int *minor_versionp\fP\^)"<Bar>echoh None<cr>
inorea fopen	fopen<c-o>:echoh HintHL<Bar>echo "FILE *fopen(const char * path, const char * mode)"<Bar>echoh None<cr>
inorea forkpty	forkpty<c-o>:echoh HintHL<Bar>echo "pid_t forkpty(int * amaster, char * name, struct termios * termp, struct winsize * winp)"<Bar>echoh None<cr>
inorea form_driver	form_driver<c-o>:echoh HintHL<Bar>echo "int form_driver(FORM *form, int c)"<Bar>echoh None<cr>
inorea form_fields	form_fields<c-o>:echoh HintHL<Bar>echo "FIELD **form_fields(const FORM *form)"<Bar>echoh None<cr>
inorea form_opts	form_opts<c-o>:echoh HintHL<Bar>echo "OPTIONS form_opts(const FORM *form)"<Bar>echoh None<cr>
inorea form_opts_off	form_opts_off<c-o>:echoh HintHL<Bar>echo "int form_opts_off(FORM *form, OPTIONS opts)"<Bar>echoh None<cr>
inorea form_opts_on	form_opts_on<c-o>:echoh HintHL<Bar>echo "int form_opts_on(FORM *form, OPTIONS opts)"<Bar>echoh None<cr>
inorea form_page	form_page<c-o>:echoh HintHL<Bar>echo "int form_page(const FORM *form)"<Bar>echoh None<cr>
inorea form_request_by_name	form_request_by_name<c-o>:echoh HintHL<Bar>echo "int form_request_by_name(const char *name)"<Bar>echoh None<cr>
inorea form_request_name	form_request_name<c-o>:echoh HintHL<Bar>echo "const char *form_request_name(int request)"<Bar>echoh None<cr>
inorea form_sub	form_sub<c-o>:echoh HintHL<Bar>echo "WINDOW *form_sub(const FORM *form)"<Bar>echoh None<cr>
inorea form_userptr	form_userptr<c-o>:echoh HintHL<Bar>echo "void* form_userptr(const FORM *form)"<Bar>echoh None<cr>
inorea form_win	form_win<c-o>:echoh HintHL<Bar>echo "WINDOW *form_win(const FORM *form)"<Bar>echoh None<cr>
inorea fpathconf	fpathconf<c-o>:echoh HintHL<Bar>echo "long fpathconf(int filedes, int name)"<Bar>echoh None<cr>
inorea fpclassify	fpclassify<c-o>:echoh HintHL<Bar>echo "int fpclassify( x)"<Bar>echoh None<cr>
inorea __fpending	__fpending<c-o>:echoh HintHL<Bar>echo "size_t __fpending(FILE * stream)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "CDstatus SDL_CDStatus\fP(SDL_CD *cdrom)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "char *SDL_GetError\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "char *SDL_GetKeyName\fP(SDLKey key)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "char *SDL_VideoDriverName\fP(char *namebuf, int maxlen)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "const char *SDL_CDName\fP(int drive)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "const char *SDL_JoystickName\fP(int index)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_BlitSurface\fP(SDL_Surface *src, SDL_Rect *srcrect, SDL_Surface *dst, SDL_Rect *dstrect)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_BuildAudioCVT\fP(SDL_AudioCVT *cvt, Uint16 src_format, Uint8 src_channels, int src_rate, Uint16 dst_format, Uint8 dst_channels, int dst_rate)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_CDEject\fP(SDL_CD *cdrom)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_CDNumDrives\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_CDPause\fP(SDL_CD *cdrom)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_CDPlay\fP(SDL_CD *cdrom, int start, int length)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_CDPlayTracks\fP(SDL_CD *cdrom, int start_track, int start_frame, int ntracks, int nframes))"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_CDResume\fP(SDL_CD *cdrom)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_CDStop\fP(SDL_CD *cdrom)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_CondBroadcast\fP(SDL_cond *cond)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_CondSignal\fP(SDL_cond *cond)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_CondWait\fP(SDL_cond *cond, SDL_mutex *mut)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_CondWaitTimeout\fP(SDL_cond *cond, SDL_mutex *mutex, Uint32 ms)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_ConvertAudio\fP(SDL_AudioCVT *cvt)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_DisplayYUVOverlay\fP(SDL_Overlay *overlay, SDL_Rect *dstrect)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_EnableKeyRepeat\fP(int delay, int interval)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_EnableUNICODE\fP(int enable)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_FillRect\fP(SDL_Surface *dst, SDL_Rect *dstrect, Uint32 color)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_Flip\fP(SDL_Surface *screen)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_GetGamma\fP(float *red, float *green, float *blue)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_GetGammaRamp\fP(Uint16 *redtable, Uint16 *greentable, Uint16 *bluetable)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_GL_GetAttribute\fP(SDLGLattr attr, int *value)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_GL_LoadLibrary\fP(const char *path)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_GL_SetAttribute\fP(SDL_GLattr attr, int value)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_Init\fP(Uint32 flags)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_InitSubSystem\fP(Uint32 flags)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_JoystickEventState\fP(int state)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_JoystickGetBall\fP(SDL_Joystick *joystick, int ball, int *dx, int *dy)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_JoystickIndex\fP(SDL_Joystick *joystick)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_JoystickNumAxes\fP(SDL_Joystick *joystick)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_JoystickNumBalls\fP(SDL_Joystick *joystick)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_JoystickNumButtons\fP(SDL_Joystick *joystick)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_JoystickNumHats\fP(SDL_Joystick *joystick)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_JoystickOpened\fP(int index)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_LockSurface\fP(SDL_Surface *surface)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_LockYUVOverlay\fP(SDL_Overlay *overlay)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_mutexP\fP(SDL_mutex *mutex)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_mutexV\fP(SDL_mutex *mutex)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_NumJoysticks\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_OpenAudio\fP(SDL_AudioSpec *desired, SDL_AudioSpec *obtained)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_PeepEvents\fP(SDL_Event *events, int numevents, SDL_eventaction action, Uint32 mask)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_PollEvent\fP(SDL_Event *event)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_PushEvent\fP(SDL_Event *event)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_SaveBMP\fP(SDL_Surface *surface, const char *file)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_SemPost\fP(SDL_sem *sem)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_SemTryWait\fP(SDL_sem *sem)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_SemWait\fP(SDL_sem *sem)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_SemWaitTimeout\fP(SDL_sem *sem, Uint32 timeout)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_SetAlpha\fP(SDL_Surface *surface, Uint32 flag, Uint8 alpha)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_SetColorKey\fP(SDL_Surface *surface, Uint32 flag, Uint32 key)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_SetColors\fP(SDL_Surface *surface, SDL_Color *colors, int firstcolor, int ncolors)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_SetGamma\fP(float redgamma, float greengamma, float bluegamma)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_SetGammaRamp\fP(Uint16 *redtable, Uint16 *greentable, Uint16 *bluetable)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_SetPalette\fP(SDL_Surface *surface, int flags, SDL_Color *colors, int firstcolor, int ncolors)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_SetTimer\fP(Uint32 interval, SDL_TimerCallback callback)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_ShowCursor\fP(int toggle)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_VideoModeOK\fP(int width, int height, int bpp, Uint32 flags)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_WaitEvent\fP(SDL_Event *event)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_WM_IconifyWindow\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "int SDL_WM_ToggleFullScreen\fP(SDL_Surface *surface)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "readline\fP (const char *prompt\fP)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "return typeSDL_FunctionName\fP(parameter)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_AudioSpec *SDL_LoadWAV\fP(const char *file, SDL_AudioSpec *spec, Uint8 **audio_buf, Uint32 *audio_len)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_audiostatusSDL_GetAudioStatus\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_bool SDL_RemoveTimer\fP(SDL_TimerID id)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_CD *SDL_CDOpen\fP(int drive)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_cond *SDL_CreateCond\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Cursor *SDL_CreateCursor\fP(Uint8 *data, Uint8 *mask, int w, int h, int hot_x, int hot_y)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Cursor *SDL_GetCursor\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_EventFilter SDL_GetEventFilter\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_GrabMode SDL_WM_GrabInput\fP(SDL_GrabMode mode)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Joystick *SDL_JoystickOpen\fP(int index)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDLMod SDL_GetModState\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_mutex *SDL_CreateMutex\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Overlay *SDL_CreateYUVOverlay\fP(int width, int height, Uint32 format, SDL_Surface *display)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Rect **SDL_ListModes\fP(SDL_PixelFormat *format, Uint32 flags)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_sem *SDL_CreateSemaphore\fP(Uint32 initial_value)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Surface *SDL_ConvertSurface\fP(SDL_Surface *src, SDL_PixelFormat *fmt, Uint32 flags)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Surface *SDL_CreateRGBSurface\fP(Uint32 flags, int width, int height, int depth, Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Surface *SDL_CreateRGBSurfaceFrom\fP(void *pixels, int width, int height, int depth, int pitch, Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Surface *SDL_DisplayFormatAlpha\fP(SDL_Surface *surface)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Surface *SDL_DisplayFormat\fP(SDL_Surface *surface)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Surface *SDL_GetVideoSurface\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Surface *SDL_LoadBMP\fP(const char *file)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Surface *SDL_SetVideoMode\fP(int width, int height, int bpp, Uint32 flags)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_Thread *SDL_CreateThread\fP(int (*fn)(void *), void *data)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_TimerID SDL_AddTimer\fP(Uint32 interval, SDL_NewTimerCallback callback, void *param)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "SDL_VideoInfo *SDL_GetVideoInfo\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Sint16 SDL_JoystickGetAxis\fP(SDL_Joystick *joystick, int axis)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint32 SDL_GetThreadID\fP(SDL_Thread *thread)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint32 SDL_GetTicks\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint32 SDL_MapRGBA\fP(SDL_PixelFormat *fmt, Uint8 r, Uint8 g, Uint8 b, Uint8 a)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint32 SDL_MapRGB\fP(SDL_PixelFormat *fmt, Uint8 r, Uint8 g, Uint8 b)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint32 SDL_SemValue\fP(SDL_sem *sem)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint32 SDL_ThreadID\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint32 SDL_WasInit\fP(Uint32 flags)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint8 SDL_EventState\fP(Uint8 type, int state)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint8 SDL_GetAppState\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint8 *SDL_GetKeyState\fP(int *numkeys)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint8 SDL_GetMouseState\fP(int *x, int *y)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint8 SDL_GetRelativeMouseState\fP(int *x, int *y)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint8 SDL_JoystickGetButton\fP(SDL_Joystick *joystick, int button)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "Uint8 SDL_JoystickGetHat\fP(SDL_Joystick *joystick, int hat)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void MrmInitialize\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_CDClose\fP(SDL_CD *cdrom)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_CloseAudio\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_Delay\fP(Uint32 ms)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_DestroyCond\fP(SDL_cond *cond)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_DestroyMutex\fP(SDL_mutex *mutex)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_DestroySemaphore\fP(SDL_sem *sem)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_FreeCursor\fP(SDL_Cursor *cursor)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_FreeSurface\fP(SDL_Surface *surface)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_FreeWAV\fP(Uint8 *audio_buf)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_FreeYUVOverlay\fP(SDL_Overlay *overlay)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_GetClipRect\fP(SDL_Surface *surface, SDL_Rect *rect)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_GetRGBA\fP(Uint32 pixel, SDL_PixelFormat *fmt, Uint8 *r, Uint8 *g, Uint8 *b, Uint8 *a)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_GetRGB\fP(Uint32 pixel, SDL_PixelFormat *fmt, Uint8 *r, Uint8 *g, Uint8 *b)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void *SDL_GL_GetProcAddress\fP(const char* proc)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_GL_SwapBuffers\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_JoystickClose\fP(SDL_Joystick *joystick)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_JoystickUpdate\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_KillThread\fP(SDL_Thread *thread)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_LockAudio\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_MixAudio\fP(Uint8 *dst, Uint8 *src, Uint32 len, int volume)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_PauseAudio\fP(int pause_on)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_PumpEvents\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_Quit\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_QuitSubSystem\fP(Uint32 flags)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_SetClipRect\fP(SDL_Surface *surface, SDL_Rect *rect)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void *SDL_SetCursor\fP(SDL_Cursor *cursor)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_SetEventFilter\fP(SDL_EventFilter filter)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_SetModState\fP(SDLMod modstate)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_UnlockAudio\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_UnlockSurface\fP(SDL_Surface *surface)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_UnlockYUVOverlay\fP(SDL_Overlay *overlay)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_UpdateRect\fP(SDL_Surface *screen, Sint32 x, Sint32 y, Sint32 w, Sint32 h)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_UpdateRects\fP(SDL_Surface *screen, int numrects, SDL_Rect *rects)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_WaitThread\fP(SDL_Thread *thread, int *status)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_WarpMouse\fP(Uint16 x, Uint16 y)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_WM_GetCaption\fP(char **title, char **icon)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_WM_SetCaption\fP(const char *title, const char *icon)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void SDL_WM_SetIcon\fP(SDL_Surface *icon, Uint8 *mask)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "void XmRepTypeInstallTearOffModelConverter\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "XmColorProc XmGetColorCalculation\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "XmRepTypeList XmRepTypeGetRegistered\fP(void)"<Bar>echoh None<cr>
inorea fP	fP<c-o>:echoh HintHL<Bar>echo "XmString XmStringSeparatorCreate\fP(void)"<Bar>echoh None<cr>
inorea fprintf	fprintf<c-o>:echoh HintHL<Bar>echo "fprintf(myfile, hello world\n)"<Bar>echoh None<cr>
inorea fprintf	fprintf<c-o>:echoh HintHL<Bar>echo "fprintf(STDOUT, temp file contains '%s'\n, buffer)"<Bar>echoh None<cr>
inorea fprintf	fprintf<c-o>:echoh HintHL<Bar>echo "int fprintf(FILE * stream, const char * format, ...)"<Bar>echoh None<cr>
inorea fpurge	fpurge<c-o>:echoh HintHL<Bar>echo "int fpurge(FILE * stream)"<Bar>echoh None<cr>
inorea __fpurge	__fpurge<c-o>:echoh HintHL<Bar>echo "void __fpurge(FILE * stream)"<Bar>echoh None<cr>
inorea fputc	fputc<c-o>:echoh HintHL<Bar>echo "int fputc(int c, FILE * stream)"<Bar>echoh None<cr>
inorea fputc_unlocked	fputc_unlocked<c-o>:echoh HintHL<Bar>echo "int fputc_unlocked(int c, FILE * stream)"<Bar>echoh None<cr>
inorea fputs	fputs<c-o>:echoh HintHL<Bar>echo "int fputs(const char * s, FILE * stream)"<Bar>echoh None<cr>
inorea fputs_unlocked	fputs_unlocked<c-o>:echoh HintHL<Bar>echo "int fputs_unlocked(const char * s, FILE * stream)"<Bar>echoh None<cr>
inorea fputwc	fputwc<c-o>:echoh HintHL<Bar>echo "wint_t fputwc(wchar_t wc, FILE * stream)"<Bar>echoh None<cr>
inorea fputwc_unlocked	fputwc_unlocked<c-o>:echoh HintHL<Bar>echo "wint_t fputwc_unlocked(wchar_t wc, FILE * stream)"<Bar>echoh None<cr>
inorea fputws	fputws<c-o>:echoh HintHL<Bar>echo "int fputws(const wchar_t * ws, FILE * stream)"<Bar>echoh None<cr>
inorea fputws_unlocked	fputws_unlocked<c-o>:echoh HintHL<Bar>echo "int fputws_unlocked(const wchar_t * ws, FILE * stream)"<Bar>echoh None<cr>
inorea __freadable	__freadable<c-o>:echoh HintHL<Bar>echo "int __freadable(FILE * stream)"<Bar>echoh None<cr>
inorea fread	fread<c-o>:echoh HintHL<Bar>echo "fread(buffer, sizeof(buffer), 1, myfile)"<Bar>echoh None<cr>
inorea fread	fread<c-o>:echoh HintHL<Bar>echo "size_t fread(void * ptr, size_t size, size_t nmemb, FILE * stream)"<Bar>echoh None<cr>
inorea __freading	__freading<c-o>:echoh HintHL<Bar>echo "int __freading(FILE * stream)"<Bar>echoh None<cr>
inorea fread_unlocked	fread_unlocked<c-o>:echoh HintHL<Bar>echo "size_t fread_unlocked(void * ptr, size_t size, size_t n, FILE * stream)"<Bar>echoh None<cr>
inorea freeaddrinfo	freeaddrinfo<c-o>:echoh HintHL<Bar>echo "void freeaddrinfo(struct addrinfo * res)"<Bar>echoh None<cr>
inorea freeconary	freeconary<c-o>:echoh HintHL<Bar>echo "void freeconary(security_context_t * con)"<Bar>echoh None<cr>
inorea freecon	freecon<c-o>:echoh HintHL<Bar>echo "void freecon(security_context_t con)"<Bar>echoh None<cr>
inorea free_field	free_field<c-o>:echoh HintHL<Bar>echo "int free_field(FIELD *field)"<Bar>echoh None<cr>
inorea free_fieldtype	free_fieldtype<c-o>:echoh HintHL<Bar>echo "int free_fieldtype(FIELDTYPE *fieldtype)"<Bar>echoh None<cr>
inorea free_form	free_form<c-o>:echoh HintHL<Bar>echo "int free_form(FORM *form)"<Bar>echoh None<cr>
inorea free	free<c-o>:echoh HintHL<Bar>echo "void free (void *ptr)"<Bar>echoh None<cr>
inorea free	free<c-o>:echoh HintHL<Bar>echo "void free(void *ptr)"<Bar>echoh None<cr>
inorea free_item	free_item<c-o>:echoh HintHL<Bar>echo "int free_item(ITEM *item)"<Bar>echoh None<cr>
inorea free_menu	free_menu<c-o>:echoh HintHL<Bar>echo "int free_menu(MENU *menu)"<Bar>echoh None<cr>
inorea freopen	freopen<c-o>:echoh HintHL<Bar>echo "FILE *freopen(const char * path, const char * mode, FILE * stream)"<Bar>echoh None<cr>
inorea frexpf	frexpf<c-o>:echoh HintHL<Bar>echo "float frexpf(float x, int * exp)"<Bar>echoh None<cr>
inorea frexp	frexp<c-o>:echoh HintHL<Bar>echo "double frexp(double x, int * exp)"<Bar>echoh None<cr>
inorea frexpl	frexpl<c-o>:echoh HintHL<Bar>echo "long double frexpl(long double x, int * exp)"<Bar>echoh None<cr>
inorea fscanf	fscanf<c-o>:echoh HintHL<Bar>echo "int fscanf(FILE * stream, const char * format, ...)"<Bar>echoh None<cr>
inorea fseek	fseek<c-o>:echoh HintHL<Bar>echo "fseek(myfile, 0, SEEK_SET)"<Bar>echoh None<cr>
inorea fseek	fseek<c-o>:echoh HintHL<Bar>echo "int fseek(FILE * stream, long offset, int whence)"<Bar>echoh None<cr>
inorea fseeko	fseeko<c-o>:echoh HintHL<Bar>echo "int fseeko(FILE * stream, off_t offset, int whence)"<Bar>echoh None<cr>
inorea fsetfilecon	fsetfilecon<c-o>:echoh HintHL<Bar>echo "int fsetfilecon(int fd, security_context_t con)"<Bar>echoh None<cr>
inorea __fsetlocking	__fsetlocking<c-o>:echoh HintHL<Bar>echo "int __fsetlocking(FILE * stream, int type)"<Bar>echoh None<cr>
inorea fsetpos	fsetpos<c-o>:echoh HintHL<Bar>echo "int fsetpos(FILE * stream, fpos_t * pos)"<Bar>echoh None<cr>
inorea ftell	ftell<c-o>:echoh HintHL<Bar>echo "long ftell(FILE * stream)"<Bar>echoh None<cr>
inorea ftello	ftello<c-o>:echoh HintHL<Bar>echo "off_t ftello(FILE * stream)"<Bar>echoh None<cr>
inorea ftime	ftime<c-o>:echoh HintHL<Bar>echo "int ftime(struct timeb * tp)"<Bar>echoh None<cr>
inorea ftok	ftok<c-o>:echoh HintHL<Bar>echo "key_t ftok(const char * pathname, int proj_id)"<Bar>echoh None<cr>
inorea ftrylockfile	ftrylockfile<c-o>:echoh HintHL<Bar>echo "int ftrylockfile(FILE * filehandle)"<Bar>echoh None<cr>
inorea func	func<c-o>:echoh HintHL<Bar>echo " C void func(int *datatype, void *x, void *y, int *num, int *info)"<Bar>echoh None<cr>
inorea func	func<c-o>:echoh HintHL<Bar>echo " Fortran call func(datatype, x, y, num, info)"<Bar>echoh None<cr>
inorea funlockfile	funlockfile<c-o>:echoh HintHL<Bar>echo "void funlockfile(FILE * filehandle)"<Bar>echoh None<cr>
inorea fwide	fwide<c-o>:echoh HintHL<Bar>echo "int fwide(FILE * stream, int mode)"<Bar>echoh None<cr>
inorea fwprintf	fwprintf<c-o>:echoh HintHL<Bar>echo "int fwprintf(FILE * stream, const wchar_t * format, ...)"<Bar>echoh None<cr>
inorea __fwritable	__fwritable<c-o>:echoh HintHL<Bar>echo "int __fwritable(FILE * stream)"<Bar>echoh None<cr>
inorea fwrite	fwrite<c-o>:echoh HintHL<Bar>echo "size_t fwrite(const void * ptr, size_t size, size_t nmemb, FILE * stream)"<Bar>echoh None<cr>
inorea fwrite_unlocked	fwrite_unlocked<c-o>:echoh HintHL<Bar>echo "size_t fwrite_unlocked(const void * ptr, size_t size, size_t n, FILE * stream)"<Bar>echoh None<cr>
inorea __fwriting	__fwriting<c-o>:echoh HintHL<Bar>echo "int __fwriting(FILE * stream)"<Bar>echoh None<cr>
inorea gai_strerror	gai_strerror<c-o>:echoh HintHL<Bar>echo "const char *gai_strerror(int errcode)"<Bar>echoh None<cr>
inorea gammaf	gammaf<c-o>:echoh HintHL<Bar>echo "float gammaf(float x)"<Bar>echoh None<cr>
inorea gamma	gamma<c-o>:echoh HintHL<Bar>echo "double gamma(double x)"<Bar>echoh None<cr>
inorea gammal	gammal<c-o>:echoh HintHL<Bar>echo "long double gammal(long double x)"<Bar>echoh None<cr>
inorea gcvt	gcvt<c-o>:echoh HintHL<Bar>echo "char *gcvt(double number, size_t ndigit, char * buf)"<Bar>echoh None<cr>
inorea gdbm_close	gdbm_close<c-o>:echoh HintHL<Bar>echo "gdbm_close (dbf)"<Bar>echoh None<cr>
inorea gdbm_delete	gdbm_delete<c-o>:echoh HintHL<Bar>echo "gdbm_delete (dbf, key)"<Bar>echoh None<cr>
inorea gdbm_exists	gdbm_exists<c-o>:echoh HintHL<Bar>echo "gdbm_exists (dbf, key)"<Bar>echoh None<cr>
inorea gdbm_fdesc	gdbm_fdesc<c-o>:echoh HintHL<Bar>echo "gdbm_fdesc (dbf)"<Bar>echoh None<cr>
inorea gdbm_fetch	gdbm_fetch<c-o>:echoh HintHL<Bar>echo "gdbm_fetch (dbf, key)"<Bar>echoh None<cr>
inorea gdbm_firstkey	gdbm_firstkey<c-o>:echoh HintHL<Bar>echo "gdbm_firstkey (dbf)"<Bar>echoh None<cr>
inorea gdbm_nextkey	gdbm_nextkey<c-o>:echoh HintHL<Bar>echo "gdbm_nextkey (dbf, key)"<Bar>echoh None<cr>
inorea gdbm_open	gdbm_open<c-o>:echoh HintHL<Bar>echo "gdbm_open (name, block_size, read_write, mode, fatal_func)"<Bar>echoh None<cr>
inorea gdbm_reorganize	gdbm_reorganize<c-o>:echoh HintHL<Bar>echo "gdbm_reorganize (dbf)"<Bar>echoh None<cr>
inorea gdbm_setopt	gdbm_setopt<c-o>:echoh HintHL<Bar>echo "gdbm_setopt (dbf, option, value, size)"<Bar>echoh None<cr>
inorea gdbm_store	gdbm_store<c-o>:echoh HintHL<Bar>echo "gdbm_store (dbf, key, content, flag)"<Bar>echoh None<cr>
inorea gdbm_strerror	gdbm_strerror<c-o>:echoh HintHL<Bar>echo "gdbm_strerror (errno)"<Bar>echoh None<cr>
inorea gdbm_sync	gdbm_sync<c-o>:echoh HintHL<Bar>echo "gdbm_sync (dbf)"<Bar>echoh None<cr>
inorea getaddrinfo	getaddrinfo<c-o>:echoh HintHL<Bar>echo "int getaddrinfo(const char * node, const char * service, const struct addrinfo * hints, struct addrinfo ** res)"<Bar>echoh None<cr>
inorea getaliasbyname	getaliasbyname<c-o>:echoh HintHL<Bar>echo "struct aliasent *getaliasbyname(const char * name)"<Bar>echoh None<cr>
inorea getaliasbyname_r	getaliasbyname_r<c-o>:echoh HintHL<Bar>echo "int getaliasbyname_r(const char * name, struct aliasent * result, char * buffer, size_t buflen, struct aliasent ** res)"<Bar>echoh None<cr>
inorea getaliasent	getaliasent<c-o>:echoh HintHL<Bar>echo "struct aliasent *getaliasent(void)"<Bar>echoh None<cr>
inorea getaliasent_r	getaliasent_r<c-o>:echoh HintHL<Bar>echo "int getaliasent_r(struct aliasent * result, char * buffer, size_t buflen, struct aliasent ** res)"<Bar>echoh None<cr>
inorea getbegyx	getbegyx<c-o>:echoh HintHL<Bar>echo "void getbegyx(WINDOW *win, int y, int x)"<Bar>echoh None<cr>
inorea getbkgd	getbkgd<c-o>:echoh HintHL<Bar>echo "chtype getbkgd(WINDOW *win)"<Bar>echoh None<cr>
inorea getbkgrnd	getbkgrnd<c-o>:echoh HintHL<Bar>echo "int getbkgrnd(cchar_t *wch)"<Bar>echoh None<cr>
inorea getc	getc<c-o>:echoh HintHL<Bar>echo "int getc(FILE * stream)"<Bar>echoh None<cr>
inorea getchar	getchar<c-o>:echoh HintHL<Bar>echo "int getchar(void)"<Bar>echoh None<cr>
inorea getchar_unlocked	getchar_unlocked<c-o>:echoh HintHL<Bar>echo "int getchar_unlocked(void)"<Bar>echoh None<cr>
inorea getch	getch<c-o>:echoh HintHL<Bar>echo "int getch(void)"<Bar>echoh None<cr>
inorea getcon	getcon<c-o>:echoh HintHL<Bar>echo "int getcon(security_context_t * context)"<Bar>echoh None<cr>
inorea getc_unlocked	getc_unlocked<c-o>:echoh HintHL<Bar>echo "int getc_unlocked(FILE * stream)"<Bar>echoh None<cr>
inorea get_current_dir_name	get_current_dir_name<c-o>:echoh HintHL<Bar>echo "char *get_current_dir_name(void)"<Bar>echoh None<cr>
inorea getcwd	getcwd<c-o>:echoh HintHL<Bar>echo "char *getcwd(char * buf, size_t size)"<Bar>echoh None<cr>
inorea getdate	getdate<c-o>:echoh HintHL<Bar>echo "struct tm *getdate (const char * string)"<Bar>echoh None<cr>
inorea getdate_r	getdate_r<c-o>:echoh HintHL<Bar>echo "int getdate_r (const char * string, struct tm * res)"<Bar>echoh None<cr>
inorea get_default_context	get_default_context<c-o>:echoh HintHL<Bar>echo "int get_default_context(const char * user, security_context_t fromcon, security_context_t * newcon)"<Bar>echoh None<cr>
inorea get_default_context_with_level	get_default_context_with_level<c-o>:echoh HintHL<Bar>echo "int get_default_context_with_level(const char * user, const char * level, security_context_t fromcon, security_context_t * newcon)"<Bar>echoh None<cr>
inorea get_default_context_with_role	get_default_context_with_role<c-o>:echoh HintHL<Bar>echo "int get_default_context_with_role(const char* user, const char * role, security_context_t fromcon, security_context_t * newcon)"<Bar>echoh None<cr>
inorea get_default_context_with_rolelevel	get_default_context_with_rolelevel<c-o>:echoh HintHL<Bar>echo "int get_default_context_with_rolelevel(const char* user, const char* level, const char * role, security_context_t fromcon, security_context_t * newcon)"<Bar>echoh None<cr>
inorea get_default_type	get_default_type<c-o>:echoh HintHL<Bar>echo "int get_default_type(const char * role, char ** type)"<Bar>echoh None<cr>
inorea getdelim	getdelim<c-o>:echoh HintHL<Bar>echo "ssize_t getdelim(char ** lineptr, size_t * n, int delim, FILE * stream)"<Bar>echoh None<cr>
inorea getenv	getenv<c-o>:echoh HintHL<Bar>echo "char *getenv(const char * name)"<Bar>echoh None<cr>
inorea getexeccon	getexeccon<c-o>:echoh HintHL<Bar>echo "int getexeccon(security_context_t * context)"<Bar>echoh None<cr>
inorea getfilecon	getfilecon<c-o>:echoh HintHL<Bar>echo "int getfilecon(const char * path, security_context_t * con)"<Bar>echoh None<cr>
inorea getfscreatecon	getfscreatecon<c-o>:echoh HintHL<Bar>echo "int getfscreatecon(security_context_t * con)"<Bar>echoh None<cr>
inorea getfsent	getfsent<c-o>:echoh HintHL<Bar>echo "struct fstab *getfsent(void)"<Bar>echoh None<cr>
inorea getfsfile	getfsfile<c-o>:echoh HintHL<Bar>echo "struct fstab *getfsfile(const char * mount_point)"<Bar>echoh None<cr>
inorea getfsspec	getfsspec<c-o>:echoh HintHL<Bar>echo "struct fstab *getfsspec(const char * special_file)"<Bar>echoh None<cr>
inorea getgrent	getgrent<c-o>:echoh HintHL<Bar>echo "struct group *getgrent(void)"<Bar>echoh None<cr>
inorea getgrent_r	getgrent_r<c-o>:echoh HintHL<Bar>echo "int getgrent_r(struct group * gbuf, char * buf, size_t buflen, struct group ** gbufp)"<Bar>echoh None<cr>
inorea getgrgid	getgrgid<c-o>:echoh HintHL<Bar>echo "struct group *getgrgid(gid_t gid)"<Bar>echoh None<cr>
inorea getgrgid_r	getgrgid_r<c-o>:echoh HintHL<Bar>echo "int getgrgid_r(gid_t gid, struct group * gbuf, char * buf, size_t buflen, struct group ** gbufp)"<Bar>echoh None<cr>
inorea getgrnam	getgrnam<c-o>:echoh HintHL<Bar>echo "struct group *getgrnam(const char * name)"<Bar>echoh None<cr>
inorea getgrnam_r	getgrnam_r<c-o>:echoh HintHL<Bar>echo "int getgrnam_r(const char * name, struct group * gbuf, char * buf, size_t buflen, struct group ** gbufp)"<Bar>echoh None<cr>
inorea gethostbyaddr	gethostbyaddr<c-o>:echoh HintHL<Bar>echo "gethostbyaddr(const void * addr, int len, int type)"<Bar>echoh None<cr>
inorea gethostbyname2	gethostbyname2<c-o>:echoh HintHL<Bar>echo "struct hostent *gethostbyname2(const char * name, int af)"<Bar>echoh None<cr>
inorea gethostbyname2_r	gethostbyname2_r<c-o>:echoh HintHL<Bar>echo "int gethostbyname2_r(const char * name, int af, struct hostent * ret, char * buf, size_t buflen, struct hostent ** result, int * h_errnop)"<Bar>echoh None<cr>
inorea gethostbyname	gethostbyname<c-o>:echoh HintHL<Bar>echo "struct hostent *gethostbyname(const char * name)"<Bar>echoh None<cr>
inorea gethostbyname_r	gethostbyname_r<c-o>:echoh HintHL<Bar>echo "int gethostbyname_r(const char * name, struct hostent * ret, char * buf, size_t buflen, struct hostent ** result, int * h_errnop)"<Bar>echoh None<cr>
inorea gethostent	gethostent<c-o>:echoh HintHL<Bar>echo "struct hostent *gethostent(void)"<Bar>echoh None<cr>
inorea getline	getline<c-o>:echoh HintHL<Bar>echo "ssize_t getline(char ** lineptr, size_t * n, FILE * stream)"<Bar>echoh None<cr>
inorea getlogin	getlogin<c-o>:echoh HintHL<Bar>echo "char *getlogin(void)"<Bar>echoh None<cr>
inorea getlogin_r	getlogin_r<c-o>:echoh HintHL<Bar>echo "int getlogin_r(char * buf, size_t bufsize)"<Bar>echoh None<cr>
inorea getmaxyx	getmaxyx<c-o>:echoh HintHL<Bar>echo "void getmaxyx(WINDOW *win, int y, int x)"<Bar>echoh None<cr>
inorea getmntent	getmntent<c-o>:echoh HintHL<Bar>echo "struct mntent *getmntent(FILE * fp)"<Bar>echoh None<cr>
inorea getmntent_r	getmntent_r<c-o>:echoh HintHL<Bar>echo "struct mntent *getmntent_r(FILE * fp, struct mntent * mntbuf, char * buf, int buflen)"<Bar>echoh None<cr>
inorea getmouse	getmouse<c-o>:echoh HintHL<Bar>echo "int getmouse(MEVENT *event)"<Bar>echoh None<cr>
inorea getnameinfo	getnameinfo<c-o>:echoh HintHL<Bar>echo "int getnameinfo(const struct sockaddr * sa, socklen_t salen, char * host, size_t hostlen, char * serv, size_t servlen, int flags)"<Bar>echoh None<cr>
inorea getnetbyaddr	getnetbyaddr<c-o>:echoh HintHL<Bar>echo "struct netent *getnetbyaddr(long net, int type)"<Bar>echoh None<cr>
inorea getnetbyname	getnetbyname<c-o>:echoh HintHL<Bar>echo "struct netent *getnetbyname(const char * name)"<Bar>echoh None<cr>
inorea getnetent	getnetent<c-o>:echoh HintHL<Bar>echo "struct netent *getnetent(void)"<Bar>echoh None<cr>
inorea getnetgrent	getnetgrent<c-o>:echoh HintHL<Bar>echo "int getnetgrent(char ** host, char ** user, char ** domain)"<Bar>echoh None<cr>
inorea getnstr	getnstr<c-o>:echoh HintHL<Bar>echo "int getnstr(char *str, int n)"<Bar>echoh None<cr>
inorea getn_wstr	getn_wstr<c-o>:echoh HintHL<Bar>echo "int getn_wstr(wint_t *wstr, int n)"<Bar>echoh None<cr>
inorea getopt	getopt<c-o>:echoh HintHL<Bar>echo "int getopt(int argc, char * const argv[], const char * optstring)"<Bar>echoh None<cr>
inorea getopt_long	getopt_long<c-o>:echoh HintHL<Bar>echo "int getopt_long(int argc, char * const argv[], const char * optstring, const struct option * longopts, int * longindex)"<Bar>echoh None<cr>
inorea getopt_long_only	getopt_long_only<c-o>:echoh HintHL<Bar>echo "int getopt_long_only(int argc, char * const argv[], const char * optstring, const struct option * longopts, int * longindex)"<Bar>echoh None<cr>
inorea get_ordered_context_list	get_ordered_context_list<c-o>:echoh HintHL<Bar>echo "int get_ordered_context_list(const char * user, security_context_t fromcon, security_context_t ** list)"<Bar>echoh None<cr>
inorea get_ordered_context_list_with_level	get_ordered_context_list_with_level<c-o>:echoh HintHL<Bar>echo "int get_ordered_context_list_with_level(const char * user, const char * level, security_context_t fromcon, security_context_t ** list)"<Bar>echoh None<cr>
inorea getparyx	getparyx<c-o>:echoh HintHL<Bar>echo "void getparyx(WINDOW *win, int y, int x)"<Bar>echoh None<cr>
inorea getpass	getpass<c-o>:echoh HintHL<Bar>echo "char *getpass( const char * prompt)"<Bar>echoh None<cr>
inorea getpeercon	getpeercon<c-o>:echoh HintHL<Bar>echo "int getpeercon(int fd, security_context_t * context)"<Bar>echoh None<cr>
inorea getpidcon	getpidcon<c-o>:echoh HintHL<Bar>echo "int getpidcon(pid_t pid, security_context_t * context)"<Bar>echoh None<cr>
inorea getprevcon	getprevcon<c-o>:echoh HintHL<Bar>echo "int getprevcon(security_context_t * context)"<Bar>echoh None<cr>
inorea getprotobyname	getprotobyname<c-o>:echoh HintHL<Bar>echo "struct protoent *getprotobyname(const char * name)"<Bar>echoh None<cr>
inorea getprotobynumber	getprotobynumber<c-o>:echoh HintHL<Bar>echo "struct protoent *getprotobynumber(int proto)"<Bar>echoh None<cr>
inorea getprotoent	getprotoent<c-o>:echoh HintHL<Bar>echo "struct protoent *getprotoent(void)"<Bar>echoh None<cr>
inorea getpt	getpt<c-o>:echoh HintHL<Bar>echo "int getpt(void)"<Bar>echoh None<cr>
inorea getpwent	getpwent<c-o>:echoh HintHL<Bar>echo "struct passwd *getpwent(void)"<Bar>echoh None<cr>
inorea getpwent_r	getpwent_r<c-o>:echoh HintHL<Bar>echo "int getpwent_r(struct passwd * pwbuf, char * buf, size_t buflen, struct passwd ** pwbufp)"<Bar>echoh None<cr>
inorea getpw	getpw<c-o>:echoh HintHL<Bar>echo "int getpw(uid_t uid, char * buf)"<Bar>echoh None<cr>
inorea getpwnam	getpwnam<c-o>:echoh HintHL<Bar>echo "struct passwd *getpwnam(const char * name)"<Bar>echoh None<cr>
inorea getpwnam_r	getpwnam_r<c-o>:echoh HintHL<Bar>echo "int getpwnam_r(const char * name, struct passwd * pwbuf, char * buf, size_t buflen, struct passwd ** pwbufp)"<Bar>echoh None<cr>
inorea getpwuid	getpwuid<c-o>:echoh HintHL<Bar>echo "struct passwd *getpwuid(uid_t uid)"<Bar>echoh None<cr>
inorea getpwuid_r	getpwuid_r<c-o>:echoh HintHL<Bar>echo "int getpwuid_r(uid_t uid, struct passwd * pwbuf, char * buf, size_t buflen, struct passwd ** pwbufp)"<Bar>echoh None<cr>
inorea getrpcbyname	getrpcbyname<c-o>:echoh HintHL<Bar>echo "struct rpcent *getrpcbyname(name)"<Bar>echoh None<cr>
inorea getrpcbynumber	getrpcbynumber<c-o>:echoh HintHL<Bar>echo "struct rpcent *getrpcbynumber(number)"<Bar>echoh None<cr>
inorea getrpcent	getrpcent<c-o>:echoh HintHL<Bar>echo "struct rpcent *getrpcent()"<Bar>echoh None<cr>
inorea getrpcport	getrpcport<c-o>:echoh HintHL<Bar>echo "int getrpcport(host, prognum, versnum, proto)"<Bar>echoh None<cr>
inorea getservbyname	getservbyname<c-o>:echoh HintHL<Bar>echo "struct servent *getservbyname(const char * name, const char * proto)"<Bar>echoh None<cr>
inorea getservbyport	getservbyport<c-o>:echoh HintHL<Bar>echo "struct servent *getservbyport(int port, const char * proto)"<Bar>echoh None<cr>
inorea getservent	getservent<c-o>:echoh HintHL<Bar>echo "struct servent *getservent(void)"<Bar>echoh None<cr>
inorea getseuserbyname	getseuserbyname<c-o>:echoh HintHL<Bar>echo "int getseuserbyname(const char * linuxuser, char ** selinuxuser, char ** level)"<Bar>echoh None<cr>
inorea gets	gets<c-o>:echoh HintHL<Bar>echo "char *gets(char * s)"<Bar>echoh None<cr>
inorea getstr	getstr<c-o>:echoh HintHL<Bar>echo "int getstr(char *str)"<Bar>echoh None<cr>
inorea getsyx	getsyx<c-o>:echoh HintHL<Bar>echo "void getsyx(int y, int x)"<Bar>echoh None<cr>
inorea getttyent	getttyent<c-o>:echoh HintHL<Bar>echo "struct ttyent *getttyent(void)"<Bar>echoh None<cr>
inorea getttynam	getttynam<c-o>:echoh HintHL<Bar>echo "struct ttyent *getttynam(const char * name)"<Bar>echoh None<cr>
inorea getumask	getumask<c-o>:echoh HintHL<Bar>echo "mode_t getumask(void)"<Bar>echoh None<cr>
inorea getusershell	getusershell<c-o>:echoh HintHL<Bar>echo "char *getusershell(void)"<Bar>echoh None<cr>
inorea getutent	getutent<c-o>:echoh HintHL<Bar>echo "struct utmp *getutent(void)"<Bar>echoh None<cr>
inorea getutid	getutid<c-o>:echoh HintHL<Bar>echo "struct utmp *getutid(struct utmp * ut)"<Bar>echoh None<cr>
inorea getutline	getutline<c-o>:echoh HintHL<Bar>echo "struct utmp *getutline(struct utmp * ut)"<Bar>echoh None<cr>
inorea getwc	getwc<c-o>:echoh HintHL<Bar>echo "wint_t getwc(FILE * stream)"<Bar>echoh None<cr>
inorea getwchar	getwchar<c-o>:echoh HintHL<Bar>echo "wint_t getwchar(void)"<Bar>echoh None<cr>
inorea getwchar_unlocked	getwchar_unlocked<c-o>:echoh HintHL<Bar>echo "wint_t getwchar_unlocked(void)"<Bar>echoh None<cr>
inorea get_wch	get_wch<c-o>:echoh HintHL<Bar>echo "int get_wch(wint_t *wch)"<Bar>echoh None<cr>
inorea getwc_unlocked	getwc_unlocked<c-o>:echoh HintHL<Bar>echo "wint_t getwc_unlocked(FILE * stream)"<Bar>echoh None<cr>
inorea getwd	getwd<c-o>:echoh HintHL<Bar>echo "char *getwd(char * buf)"<Bar>echoh None<cr>
inorea getw	getw<c-o>:echoh HintHL<Bar>echo "int getw(FILE * stream)"<Bar>echoh None<cr>
inorea getwin	getwin<c-o>:echoh HintHL<Bar>echo "WINDOW *getwin(FILE *filep)"<Bar>echoh None<cr>
inorea get_wstr	get_wstr<c-o>:echoh HintHL<Bar>echo "int get_wstr(wint_t *wstr)"<Bar>echoh None<cr>
inorea getyx	getyx<c-o>:echoh HintHL<Bar>echo "void getyx(WINDOW *win, int y, int x)"<Bar>echoh None<cr>
inorea globfree	globfree<c-o>:echoh HintHL<Bar>echo "void globfree(glob_t * pglob)"<Bar>echoh None<cr>
inorea glob	glob<c-o>:echoh HintHL<Bar>echo "int glob(const char * pattern, int flags, int errfunc (const char * epath, int eerrno), glob_t * pglob)"<Bar>echoh None<cr>
inorea gmtime	gmtime<c-o>:echoh HintHL<Bar>echo "struct tm *gmtime(const time_t * timep)"<Bar>echoh None<cr>
inorea gmtime_r	gmtime_r<c-o>:echoh HintHL<Bar>echo "struct tm *gmtime_r(const time_t * timep, struct tm * result)"<Bar>echoh None<cr>
inorea grantpt	grantpt<c-o>:echoh HintHL<Bar>echo "int grantpt(int fd)"<Bar>echoh None<cr>
inorea gsignal	gsignal<c-o>:echoh HintHL<Bar>echo "int gsignal( signum)"<Bar>echoh None<cr>
inorea halfdelay	halfdelay<c-o>:echoh HintHL<Bar>echo "int halfdelay(int tenths)"<Bar>echoh None<cr>
inorea has_colors	has_colors<c-o>:echoh HintHL<Bar>echo "bool has_colors(void)"<Bar>echoh None<cr>
inorea has_ic	has_ic<c-o>:echoh HintHL<Bar>echo "bool has_ic(void)"<Bar>echoh None<cr>
inorea has_il	has_il<c-o>:echoh HintHL<Bar>echo "bool has_il(void)"<Bar>echoh None<cr>
inorea has_key	has_key<c-o>:echoh HintHL<Bar>echo "int has_key(int ch)"<Bar>echoh None<cr>
inorea hasmntopt	hasmntopt<c-o>:echoh HintHL<Bar>echo "char *hasmntopt(const struct mntent * mnt, const char * opt)"<Bar>echoh None<cr>
inorea hcreate	hcreate<c-o>:echoh HintHL<Bar>echo "int hcreate(size_t nel)"<Bar>echoh None<cr>
inorea hcreate_r	hcreate_r<c-o>:echoh HintHL<Bar>echo "int hcreate_r(size_t nel, struct hsearch_data * tab)"<Bar>echoh None<cr>
inorea hdestroy	hdestroy<c-o>:echoh HintHL<Bar>echo "void hdestroy(void)"<Bar>echoh None<cr>
inorea hdestroy_r	hdestroy_r<c-o>:echoh HintHL<Bar>echo "void hdestroy_r(struct hsearch_data * tab)"<Bar>echoh None<cr>
inorea herror	herror<c-o>:echoh HintHL<Bar>echo "void herror(const char * s)"<Bar>echoh None<cr>
inorea hesiod_end	hesiod_end<c-o>:echoh HintHL<Bar>echo "void hesiod_end(void *context\fP)"<Bar>echoh None<cr>
inorea hesiod_free_list	hesiod_free_list<c-o>:echoh HintHL<Bar>echo "void hesiod_free_list(void *context\fP, char **list\fP)"<Bar>echoh None<cr>
inorea hesiod_free_passwd	hesiod_free_passwd<c-o>:echoh HintHL<Bar>echo "void hesiod_free_passwd(void *context\fP, struct passwd *pw\fP)"<Bar>echoh None<cr>
inorea hesiod_free_postoffice	hesiod_free_postoffice<c-o>:echoh HintHL<Bar>echo "void hesiod_free_postoffice(void *context\fP, struct hesiod_postoffice *po\fP)"<Bar>echoh None<cr>
inorea hesiod_free_servent	hesiod_free_servent<c-o>:echoh HintHL<Bar>echo "void hesiod_free_servent(void *context\fP, struct servent *serv\fP)"<Bar>echoh None<cr>
inorea hesiod_getmailhost	hesiod_getmailhost<c-o>:echoh HintHL<Bar>echo "struct hesiod_postoffice *hesiod_getmailhost(void *context\fP, const char *user\fP)"<Bar>echoh None<cr>
inorea hesiod_getpwnam	hesiod_getpwnam<c-o>:echoh HintHL<Bar>echo "struct passwd *hesiod_getpwnam(void *context\fP, const char *name\fP)"<Bar>echoh None<cr>
inorea hesiod_getpwuid	hesiod_getpwuid<c-o>:echoh HintHL<Bar>echo "struct passwd *hesiod_getpwuid(void *context\fP, uid_t uid\fP)"<Bar>echoh None<cr>
inorea hesiod_getservbyname	hesiod_getservbyname<c-o>:echoh HintHL<Bar>echo "struct servent *hesiod_getservbyname(void *context\fP, const char *name\fP, const char *proto\fP)"<Bar>echoh None<cr>
inorea hesiod_init	hesiod_init<c-o>:echoh HintHL<Bar>echo "int hesiod_init(void **context\fP)"<Bar>echoh None<cr>
inorea hesiod_resolve	hesiod_resolve<c-o>:echoh HintHL<Bar>echo "char **hesiod_resolve(void *context\fP, const char *name\fP, const char *type\fP)"<Bar>echoh None<cr>
inorea hesiod_to_bind	hesiod_to_bind<c-o>:echoh HintHL<Bar>echo "char *hesiod_to_bind(void *context\fP, const char *name\fP, const char *type\fP)"<Bar>echoh None<cr>
inorea hide_panel	hide_panel<c-o>:echoh HintHL<Bar>echo "int hide_panel(PANEL *pan)"<Bar>echoh None<cr>
inorea hline	hline<c-o>:echoh HintHL<Bar>echo "int hline(chtype ch, int n)"<Bar>echoh None<cr>
inorea hosts_access	hosts_access<c-o>:echoh HintHL<Bar>echo "int hosts_access(request)"<Bar>echoh None<cr>
inorea hosts_ctl	hosts_ctl<c-o>:echoh HintHL<Bar>echo "int hosts_ctl(daemon, client_name, client_addr, client_user)"<Bar>echoh None<cr>
inorea hsearch	hsearch<c-o>:echoh HintHL<Bar>echo "ENTRY *hsearch(ENTRY item, ACTION action)"<Bar>echoh None<cr>
inorea hsearch_r	hsearch_r<c-o>:echoh HintHL<Bar>echo "int hsearch_r(ENTRY item, ACTION action, ENTRY ** ret, struct hsearch_data * tab)"<Bar>echoh None<cr>
inorea hstrerror	hstrerror<c-o>:echoh HintHL<Bar>echo "const char *hstrerror(int err)"<Bar>echoh None<cr>
inorea htonl	htonl<c-o>:echoh HintHL<Bar>echo "uint32_t htonl(uint32_t hostlong)"<Bar>echoh None<cr>
inorea htons	htons<c-o>:echoh HintHL<Bar>echo "uint16_t htons(uint16_t hostshort)"<Bar>echoh None<cr>
inorea hypotf	hypotf<c-o>:echoh HintHL<Bar>echo "float hypotf(float x, float y)"<Bar>echoh None<cr>
inorea hypot	hypot<c-o>:echoh HintHL<Bar>echo "double hypot(double x, double y)"<Bar>echoh None<cr>
inorea hypotl	hypotl<c-o>:echoh HintHL<Bar>echo "long double hypotl (long double x, long double y)"<Bar>echoh None<cr>
inorea iconv_close	iconv_close<c-o>:echoh HintHL<Bar>echo "int iconv_close(iconv_t cd)"<Bar>echoh None<cr>
inorea iconv	iconv<c-o>:echoh HintHL<Bar>echo "size_t iconv(iconv_t cd, char ** inbuf, size_t * inbytesleft, char ** outbuf, size_t * outbytesleft)"<Bar>echoh None<cr>
inorea iconv_open	iconv_open<c-o>:echoh HintHL<Bar>echo "iconv_t iconv_open(const char * tocode, const char * fromcode)"<Bar>echoh None<cr>
inorea idcok	idcok<c-o>:echoh HintHL<Bar>echo "void idcok(WINDOW *win, bool bf)"<Bar>echoh None<cr>
inorea idlok	idlok<c-o>:echoh HintHL<Bar>echo "int idlok(WINDOW *win, bool bf)"<Bar>echoh None<cr>
inorea idna_strerror	idna_strerror<c-o>:echoh HintHL<Bar>echo "const char * idna_strerror(Idna_rc rc)"<Bar>echoh None<cr>
inorea idna_to_ascii_4i	idna_to_ascii_4i<c-o>:echoh HintHL<Bar>echo "int idna_to_ascii_4i(const uint32_t * in, size_t inlen, char * out, int flags)"<Bar>echoh None<cr>
inorea idna_to_ascii_4z	idna_to_ascii_4z<c-o>:echoh HintHL<Bar>echo "int idna_to_ascii_4z(const uint32_t * input, char ** output, int flags)"<Bar>echoh None<cr>
inorea idna_to_ascii_8z	idna_to_ascii_8z<c-o>:echoh HintHL<Bar>echo "int idna_to_ascii_8z(const char * input, char ** output, int flags)"<Bar>echoh None<cr>
inorea idna_to_ascii_lz	idna_to_ascii_lz<c-o>:echoh HintHL<Bar>echo "int idna_to_ascii_lz(const char * input, char ** output, int flags)"<Bar>echoh None<cr>
inorea idna_to_unicode_44i	idna_to_unicode_44i<c-o>:echoh HintHL<Bar>echo "int idna_to_unicode_44i(const uint32_t * in, size_t inlen, uint32_t * out, size_t * outlen, int flags)"<Bar>echoh None<cr>
inorea idna_to_unicode_4z4z	idna_to_unicode_4z4z<c-o>:echoh HintHL<Bar>echo "int idna_to_unicode_4z4z(const uint32_t * input, uint32_t ** output, int flags)"<Bar>echoh None<cr>
inorea idna_to_unicode_8z4z	idna_to_unicode_8z4z<c-o>:echoh HintHL<Bar>echo "int idna_to_unicode_8z4z(const char * input, uint32_t ** output, int flags)"<Bar>echoh None<cr>
inorea idna_to_unicode_8z8z	idna_to_unicode_8z8z<c-o>:echoh HintHL<Bar>echo "int idna_to_unicode_8z8z(const char * input, char ** output, int flags)"<Bar>echoh None<cr>
inorea idna_to_unicode_8zlz	idna_to_unicode_8zlz<c-o>:echoh HintHL<Bar>echo "int idna_to_unicode_8zlz(const char * input, char ** output, int flags)"<Bar>echoh None<cr>
inorea idna_to_unicode_lzlz	idna_to_unicode_lzlz<c-o>:echoh HintHL<Bar>echo "int idna_to_unicode_lzlz(const char * input, char ** output, int flags)"<Bar>echoh None<cr>
inorea ilogbf	ilogbf<c-o>:echoh HintHL<Bar>echo "int ilogbf(float x)"<Bar>echoh None<cr>
inorea ilogb	ilogb<c-o>:echoh HintHL<Bar>echo "int ilogb(double x)"<Bar>echoh None<cr>
inorea ilogbl	ilogbl<c-o>:echoh HintHL<Bar>echo "int ilogbl(long double x)"<Bar>echoh None<cr>
inorea imaxabs	imaxabs<c-o>:echoh HintHL<Bar>echo "intmax_t imaxabs(intmax_t j)"<Bar>echoh None<cr>
inorea imaxdiv	imaxdiv<c-o>:echoh HintHL<Bar>echo "imaxdiv_t imaxdiv(intmax_t numerator, intmax_t denominator)"<Bar>echoh None<cr>
inorea immedok	immedok<c-o>:echoh HintHL<Bar>echo "void immedok(WINDOW *win, bool bf)"<Bar>echoh None<cr>
inorea inch	inch<c-o>:echoh HintHL<Bar>echo "chtype inch(void)"<Bar>echoh None<cr>
inorea inchnstr	inchnstr<c-o>:echoh HintHL<Bar>echo "int inchnstr(chtype *chstr, int n)"<Bar>echoh None<cr>
inorea inchstr	inchstr<c-o>:echoh HintHL<Bar>echo "int inchstr(chtype *chstr)"<Bar>echoh None<cr>
inorea index	index<c-o>:echoh HintHL<Bar>echo "char *index(const char * s, int c)"<Bar>echoh None<cr>
inorea inet_addr	inet_addr<c-o>:echoh HintHL<Bar>echo "in_addr_t inet_addr(const char * cp)"<Bar>echoh None<cr>
inorea inet_aton	inet_aton<c-o>:echoh HintHL<Bar>echo "int inet_aton(const char * cp, struct in_addr * inp)"<Bar>echoh None<cr>
inorea inet_lnaof	inet_lnaof<c-o>:echoh HintHL<Bar>echo "in_addr_t inet_lnaof(struct in_addr in)"<Bar>echoh None<cr>
inorea inet_makeaddr	inet_makeaddr<c-o>:echoh HintHL<Bar>echo "struct in_addr inet_makeaddr(int net, int host)"<Bar>echoh None<cr>
inorea inet_netof	inet_netof<c-o>:echoh HintHL<Bar>echo "in_addr_t inet_netof(struct in_addr in)"<Bar>echoh None<cr>
inorea inet_network	inet_network<c-o>:echoh HintHL<Bar>echo "in_addr_t inet_network(const char * cp)"<Bar>echoh None<cr>
inorea inet_ntoa	inet_ntoa<c-o>:echoh HintHL<Bar>echo "char *inet_ntoa(struct in_addr in)"<Bar>echoh None<cr>
inorea inet_ntop	inet_ntop<c-o>:echoh HintHL<Bar>echo "const char *inet_ntop(int af, const void * src, char * dst, socklen_t cnt)"<Bar>echoh None<cr>
inorea inet_pton	inet_pton<c-o>:echoh HintHL<Bar>echo "int inet_pton(int af, const char * src, void * dst)"<Bar>echoh None<cr>
inorea init_color	init_color<c-o>:echoh HintHL<Bar>echo "int init_color(short color, short r, short g, short b)"<Bar>echoh None<cr>
inorea initgroups	initgroups<c-o>:echoh HintHL<Bar>echo "int initgroups(const char * user, gid_t group)"<Bar>echoh None<cr>
inorea initialize_XXXX_error_table	initialize_XXXX_error_table<c-o>:echoh HintHL<Bar>echo "void initialize_XXXX_error_table ()"<Bar>echoh None<cr>
inorea init_pair	init_pair<c-o>:echoh HintHL<Bar>echo "int init_pair(short pair, short f, short b)"<Bar>echoh None<cr>
inorea initscr	initscr<c-o>:echoh HintHL<Bar>echo "WINDOW *initscr(void)"<Bar>echoh None<cr>
inorea initstate	initstate<c-o>:echoh HintHL<Bar>echo "char *initstate(unsigned int seed, char * state, size_t n)"<Bar>echoh None<cr>
inorea innstr	innstr<c-o>:echoh HintHL<Bar>echo "int innstr(char *str, int n)"<Bar>echoh None<cr>
inorea innwstr	innwstr<c-o>:echoh HintHL<Bar>echo "int innwstr(wchar_t *str, int n)"<Bar>echoh None<cr>
inorea insch	insch<c-o>:echoh HintHL<Bar>echo "int insch(chtype ch)"<Bar>echoh None<cr>
inorea insdelln	insdelln<c-o>:echoh HintHL<Bar>echo "int insdelln(int n)"<Bar>echoh None<cr>
inorea insertln	insertln<c-o>:echoh HintHL<Bar>echo "int insertln(void)"<Bar>echoh None<cr>
inorea insnstr	insnstr<c-o>:echoh HintHL<Bar>echo "int insnstr(const char *str, int n)"<Bar>echoh None<cr>
inorea ins_nwstr	ins_nwstr<c-o>:echoh HintHL<Bar>echo "int ins_nwstr(const wchar_t *wstr, int n)"<Bar>echoh None<cr>
inorea insque	insque<c-o>:echoh HintHL<Bar>echo "void insque(void * elem, void * prev)"<Bar>echoh None<cr>
inorea insstr	insstr<c-o>:echoh HintHL<Bar>echo "int insstr(const char *str)"<Bar>echoh None<cr>
inorea instr	instr<c-o>:echoh HintHL<Bar>echo "int instr(char *str)"<Bar>echoh None<cr>
inorea ins_wch	ins_wch<c-o>:echoh HintHL<Bar>echo "int ins_wch(const cchar_t *wch)"<Bar>echoh None<cr>
inorea ins_wstr	ins_wstr<c-o>:echoh HintHL<Bar>echo "int ins_wstr(const wchar_t *wstr)"<Bar>echoh None<cr>
inorea int	int<c-o>:echoh HintHL<Bar>echo "fts_open char * const *path_argv int options int (*compar)(const FTSENT **, const FTSENT **)"<Bar>echoh None<cr>
inorea int	int<c-o>:echoh HintHL<Bar>echo "int (*cmp)()"<Bar>echoh None<cr>
inorea int	int<c-o>:echoh HintHL<Bar>echo "int(* compar)(const void *, const void *))"<Bar>echoh None<cr>
inorea int	int<c-o>:echoh HintHL<Bar>echo " int (*conv)(int num_msg, const struct pam_message **msg, struct pam_response **resp, void *appdata_ptr)"<Bar>echoh None<cr>
inorea int	int<c-o>:echoh HintHL<Bar>echo "int (*rebindproc)()"<Bar>echoh None<cr>
inorea int	int<c-o>:echoh HintHL<Bar>echo "typedef int (*TIFFCloseProc)(thandle_t)"<Bar>echoh None<cr>
inorea int	int<c-o>:echoh HintHL<Bar>echo "typedef int (*TIFFMapFileProc)(thandle_t, tdata_t*, toff_t*)"<Bar>echoh None<cr>
inorea intne_addr_result	intne_addr_result<c-o>:echoh HintHL<Bar>echo "intne_addr_result(constne_sock_addr*addr)"<Bar>echoh None<cr>
inorea intne_iaddr_cmp	intne_iaddr_cmp<c-o>:echoh HintHL<Bar>echo "intne_iaddr_cmp(constne_inet_addr*ia1, constne_inet_addr*ia2)"<Bar>echoh None<cr>
inorea intne_request_dispatch	intne_request_dispatch<c-o>:echoh HintHL<Bar>echo "intne_request_dispatch(ne_request*req)"<Bar>echoh None<cr>
inorea intne_sock_init	intne_sock_init<c-o>:echoh HintHL<Bar>echo "intne_sock_init(void)"<Bar>echoh None<cr>
inorea intne_ssl_cert_cmp	intne_ssl_cert_cmp<c-o>:echoh HintHL<Bar>echo "intne_ssl_cert_cmp(constne_ssl_certificate*c1, constne_ssl_certificate*c2)"<Bar>echoh None<cr>
inorea intne_ssl_cert_write	intne_ssl_cert_write<c-o>:echoh HintHL<Bar>echo "intne_ssl_cert_write(constne_ssl_certificate*cert, constchar*filename)"<Bar>echoh None<cr>
inorea intne_ssl_clicert_decrypt	intne_ssl_clicert_decrypt<c-o>:echoh HintHL<Bar>echo "intne_ssl_clicert_decrypt(ne_ssl_client_cert*ccert, constchar*password)"<Bar>echoh None<cr>
inorea intne_ssl_clicert_encrypted	intne_ssl_clicert_encrypted<c-o>:echoh HintHL<Bar>echo "intne_ssl_clicert_encrypted(constne_ssl_client_cert*ccert)"<Bar>echoh None<cr>
inorea intne_ssl_dname_cmp	intne_ssl_dname_cmp<c-o>:echoh HintHL<Bar>echo "intne_ssl_dname_cmp(constne_ssl_dname*dn1, constne_ssl_dname*dn2)"<Bar>echoh None<cr>
inorea intne_version_match	intne_version_match<c-o>:echoh HintHL<Bar>echo "intne_version_match(intmajor, intminor)"<Bar>echoh None<cr>
inorea intrflush	intrflush<c-o>:echoh HintHL<Bar>echo "int intrflush(WINDOW *win, bool bf)"<Bar>echoh None<cr>
inorea in_wch	in_wch<c-o>:echoh HintHL<Bar>echo "int in_wch(cchar_t *wcval)"<Bar>echoh None<cr>
inorea in_wchnstr	in_wchnstr<c-o>:echoh HintHL<Bar>echo "int in_wchnstr(cchar_t *wchstr, int n)"<Bar>echoh None<cr>
inorea in_wchstr	in_wchstr<c-o>:echoh HintHL<Bar>echo "int in_wchstr(cchar_t *wchstr)"<Bar>echoh None<cr>
inorea inwstr	inwstr<c-o>:echoh HintHL<Bar>echo "int inwstr(wchar_t *str)"<Bar>echoh None<cr>
inorea isalnum	isalnum<c-o>:echoh HintHL<Bar>echo "int isalnum(int c)"<Bar>echoh None<cr>
inorea isalpha	isalpha<c-o>:echoh HintHL<Bar>echo "int isalpha(int c)"<Bar>echoh None<cr>
inorea isascii	isascii<c-o>:echoh HintHL<Bar>echo "int isascii(int c)"<Bar>echoh None<cr>
inorea isatty	isatty<c-o>:echoh HintHL<Bar>echo "int isatty(int desc)"<Bar>echoh None<cr>
inorea isblank	isblank<c-o>:echoh HintHL<Bar>echo "int isblank(int c)"<Bar>echoh None<cr>
inorea iscntrl	iscntrl<c-o>:echoh HintHL<Bar>echo "int iscntrl(int c)"<Bar>echoh None<cr>
inorea is_context_customizable	is_context_customizable<c-o>:echoh HintHL<Bar>echo "int is_context_customizable(security_context_t scon)"<Bar>echoh None<cr>
inorea isdigit	isdigit<c-o>:echoh HintHL<Bar>echo "int isdigit(int c)"<Bar>echoh None<cr>
inorea isendwin	isendwin<c-o>:echoh HintHL<Bar>echo "bool isendwin(void)"<Bar>echoh None<cr>
inorea isfinite	isfinite<c-o>:echoh HintHL<Bar>echo "int isfinite( x)"<Bar>echoh None<cr>
inorea isgraph	isgraph<c-o>:echoh HintHL<Bar>echo "int isgraph(int c)"<Bar>echoh None<cr>
inorea isgreaterequal	isgreaterequal<c-o>:echoh HintHL<Bar>echo "int isgreaterequal(x,y)"<Bar>echoh None<cr>
inorea isgreater	isgreater<c-o>:echoh HintHL<Bar>echo "int isgreater(x,y)"<Bar>echoh None<cr>
inorea isinff	isinff<c-o>:echoh HintHL<Bar>echo "int isinff(float x)"<Bar>echoh None<cr>
inorea isinf	isinf<c-o>:echoh HintHL<Bar>echo "int isinf(double x)"<Bar>echoh None<cr>
inorea isinf	isinf<c-o>:echoh HintHL<Bar>echo "int isinf( x)"<Bar>echoh None<cr>
inorea isinfl	isinfl<c-o>:echoh HintHL<Bar>echo "int isinfl(long double x)"<Bar>echoh None<cr>
inorea islessequal	islessequal<c-o>:echoh HintHL<Bar>echo "int islessequal(x,y)"<Bar>echoh None<cr>
inorea islessgreater	islessgreater<c-o>:echoh HintHL<Bar>echo "int islessgreater(x,y)"<Bar>echoh None<cr>
inorea isless	isless<c-o>:echoh HintHL<Bar>echo "int isless(x,y)"<Bar>echoh None<cr>
inorea is_linetouched	is_linetouched<c-o>:echoh HintHL<Bar>echo "bool is_linetouched(WINDOW *win, int line)"<Bar>echoh None<cr>
inorea islower	islower<c-o>:echoh HintHL<Bar>echo "int islower(int c)"<Bar>echoh None<cr>
inorea isnanf	isnanf<c-o>:echoh HintHL<Bar>echo "int isnanf(float x)"<Bar>echoh None<cr>
inorea isnan	isnan<c-o>:echoh HintHL<Bar>echo "int isnan(double x)"<Bar>echoh None<cr>
inorea isnan	isnan<c-o>:echoh HintHL<Bar>echo "int isnan( x)"<Bar>echoh None<cr>
inorea isnanl	isnanl<c-o>:echoh HintHL<Bar>echo "int isnanl(long double x)"<Bar>echoh None<cr>
inorea isnormal	isnormal<c-o>:echoh HintHL<Bar>echo "int isnormal( x)"<Bar>echoh None<cr>
inorea isprint	isprint<c-o>:echoh HintHL<Bar>echo "int isprint(int c)"<Bar>echoh None<cr>
inorea ispunct	ispunct<c-o>:echoh HintHL<Bar>echo "int ispunct(int c)"<Bar>echoh None<cr>
inorea is_selinux_enabled	is_selinux_enabled<c-o>:echoh HintHL<Bar>echo "int is_selinux_enabled()"<Bar>echoh None<cr>
inorea isspace	isspace<c-o>:echoh HintHL<Bar>echo "int isspace(int c)"<Bar>echoh None<cr>
inorea is_term_resized	is_term_resized<c-o>:echoh HintHL<Bar>echo "bool is_term_resized(int lines, int columns)"<Bar>echoh None<cr>
inorea isunordered	isunordered<c-o>:echoh HintHL<Bar>echo "int isunordered(x,y)"<Bar>echoh None<cr>
inorea isupper	isupper<c-o>:echoh HintHL<Bar>echo "int isupper(int c)"<Bar>echoh None<cr>
inorea iswalnum	iswalnum<c-o>:echoh HintHL<Bar>echo "int iswalnum(wint_t wc)"<Bar>echoh None<cr>
inorea iswalpha	iswalpha<c-o>:echoh HintHL<Bar>echo "int iswalpha(wint_t wc)"<Bar>echoh None<cr>
inorea iswblank	iswblank<c-o>:echoh HintHL<Bar>echo "int iswblank(wint_t wc)"<Bar>echoh None<cr>
inorea iswcntrl	iswcntrl<c-o>:echoh HintHL<Bar>echo "int iswcntrl(wint_t wc)"<Bar>echoh None<cr>
inorea iswctype	iswctype<c-o>:echoh HintHL<Bar>echo "int iswctype(wint_t wc, wctype_t desc)"<Bar>echoh None<cr>
inorea iswdigit	iswdigit<c-o>:echoh HintHL<Bar>echo "int iswdigit(wint_t wc)"<Bar>echoh None<cr>
inorea iswgraph	iswgraph<c-o>:echoh HintHL<Bar>echo "int iswgraph(wint_t wc)"<Bar>echoh None<cr>
inorea is_wintouched	is_wintouched<c-o>:echoh HintHL<Bar>echo "bool is_wintouched(WINDOW *win)"<Bar>echoh None<cr>
inorea iswlower	iswlower<c-o>:echoh HintHL<Bar>echo "int iswlower(wint_t wc)"<Bar>echoh None<cr>
inorea iswprint	iswprint<c-o>:echoh HintHL<Bar>echo "int iswprint(wint_t wc)"<Bar>echoh None<cr>
inorea iswpunct	iswpunct<c-o>:echoh HintHL<Bar>echo "int iswpunct(wint_t wc)"<Bar>echoh None<cr>
inorea iswspace	iswspace<c-o>:echoh HintHL<Bar>echo "int iswspace(wint_t wc)"<Bar>echoh None<cr>
inorea iswupper	iswupper<c-o>:echoh HintHL<Bar>echo "int iswupper(wint_t wc)"<Bar>echoh None<cr>
inorea iswxdigit	iswxdigit<c-o>:echoh HintHL<Bar>echo "int iswxdigit(wint_t wc)"<Bar>echoh None<cr>
inorea isxdigit	isxdigit<c-o>:echoh HintHL<Bar>echo "int isxdigit(int c)"<Bar>echoh None<cr>
inorea item_count	item_count<c-o>:echoh HintHL<Bar>echo "int item_count(const MENU *menu)"<Bar>echoh None<cr>
inorea item_description	item_description<c-o>:echoh HintHL<Bar>echo "const char *item_description(const ITEM *item)"<Bar>echoh None<cr>
inorea item_index	item_index<c-o>:echoh HintHL<Bar>echo "int item_index(const ITEM *item)"<Bar>echoh None<cr>
inorea item_name	item_name<c-o>:echoh HintHL<Bar>echo "const char *item_name(const ITEM *item)"<Bar>echoh None<cr>
inorea item_opts	item_opts<c-o>:echoh HintHL<Bar>echo "OPTIONS item_opts(const ITEM *item)"<Bar>echoh None<cr>
inorea item_opts_off	item_opts_off<c-o>:echoh HintHL<Bar>echo "int item_opts_off(ITEM *item, OPTIONS opts)"<Bar>echoh None<cr>
inorea item_opts_on	item_opts_on<c-o>:echoh HintHL<Bar>echo "int item_opts_on(ITEM *item, OPTIONS opts)"<Bar>echoh None<cr>
inorea item_userptr	item_userptr<c-o>:echoh HintHL<Bar>echo "void *item_userptr(const ITEM *item)"<Bar>echoh None<cr>
inorea item_value	item_value<c-o>:echoh HintHL<Bar>echo "bool item_value(const ITEM *item)"<Bar>echoh None<cr>
inorea item_visible	item_visible<c-o>:echoh HintHL<Bar>echo "bool item_visible(const ITEM *item)"<Bar>echoh None<cr>
inorea j0f	j0f<c-o>:echoh HintHL<Bar>echo "float j0f(float x)"<Bar>echoh None<cr>
inorea j0	j0<c-o>:echoh HintHL<Bar>echo "double j0(double x)"<Bar>echoh None<cr>
inorea j0l	j0l<c-o>:echoh HintHL<Bar>echo "long double j0l(long double x)"<Bar>echoh None<cr>
inorea j1f	j1f<c-o>:echoh HintHL<Bar>echo "float j1f(float x)"<Bar>echoh None<cr>
inorea j1	j1<c-o>:echoh HintHL<Bar>echo "double j1(double x)"<Bar>echoh None<cr>
inorea j1l	j1l<c-o>:echoh HintHL<Bar>echo "long double j1l(long double x)"<Bar>echoh None<cr>
inorea jnf	jnf<c-o>:echoh HintHL<Bar>echo "float jnf(int n, float x)"<Bar>echoh None<cr>
inorea jn	jn<c-o>:echoh HintHL<Bar>echo "double jn(int n, double x)"<Bar>echoh None<cr>
inorea jnl	jnl<c-o>:echoh HintHL<Bar>echo "long double jnl(int n, long double x)"<Bar>echoh None<cr>
inorea jrand48	jrand48<c-o>:echoh HintHL<Bar>echo "long int jrand48(unsigned short xsubi [3])"<Bar>echoh None<cr>
inorea jrand48_r	jrand48_r<c-o>:echoh HintHL<Bar>echo "int jrand48_r(unsigned short int xsubi[3], struct drand48_data * buffer, long int * result)"<Bar>echoh None<cr>
inorea key_decryptsession	key_decryptsession<c-o>:echoh HintHL<Bar>echo "int key_decryptsession(const char * remotename, des_block * deskey)"<Bar>echoh None<cr>
inorea key_encryptsession	key_encryptsession<c-o>:echoh HintHL<Bar>echo "int key_encryptsession(const char * remotename, des_block * deskey)"<Bar>echoh None<cr>
inorea key_gendes	key_gendes<c-o>:echoh HintHL<Bar>echo "int key_gendes(des_block * deskey)"<Bar>echoh None<cr>
inorea keyname	keyname<c-o>:echoh HintHL<Bar>echo "char *keyname(int c)"<Bar>echoh None<cr>
inorea key_name	key_name<c-o>:echoh HintHL<Bar>echo "char *key_name(wchar_t w)"<Bar>echoh None<cr>
inorea keypad	keypad<c-o>:echoh HintHL<Bar>echo "int keypad(WINDOW *win, bool bf)"<Bar>echoh None<cr>
inorea key_secretkey_is_set	key_secretkey_is_set<c-o>:echoh HintHL<Bar>echo "int key_secretkey_is_set(void)"<Bar>echoh None<cr>
inorea key_setsecret	key_setsecret<c-o>:echoh HintHL<Bar>echo "int key_setsecret(const char * key)"<Bar>echoh None<cr>
inorea killchar	killchar<c-o>:echoh HintHL<Bar>echo "char killchar(void)"<Bar>echoh None<cr>
inorea killpg	killpg<c-o>:echoh HintHL<Bar>echo "int killpg(pid_t pgrp, int signal)"<Bar>echoh None<cr>
inorea killwchar	killwchar<c-o>:echoh HintHL<Bar>echo "int killwchar(wchar_t *ch)"<Bar>echoh None<cr>
inorea l64a	l64a<c-o>:echoh HintHL<Bar>echo "char *l64a(long value)"<Bar>echoh None<cr>
inorea labs	labs<c-o>:echoh HintHL<Bar>echo "long int labs(long int j)"<Bar>echoh None<cr>
inorea lcong48	lcong48<c-o>:echoh HintHL<Bar>echo "void lcong48(unsigned short param [7])"<Bar>echoh None<cr>
inorea lcong48_r	lcong48_r<c-o>:echoh HintHL<Bar>echo "int lcong48_r(unsigned short int param[7], struct drand48_data * buffer)"<Bar>echoh None<cr>
inorea ldap_abandon_ext	ldap_abandon_ext<c-o>:echoh HintHL<Bar>echo "int ldap_abandon_ext(LDAP * ld, int msgid, LDAPControl * sctrls [], LDAPControl * cctrls [])"<Bar>echoh None<cr>
inorea ldap_abandon	ldap_abandon<c-o>:echoh HintHL<Bar>echo "int ldap_abandon(LDAP * ld, int msgid)"<Bar>echoh None<cr>
inorea ldap_add_ext	ldap_add_ext<c-o>:echoh HintHL<Bar>echo "int ldap_add_ext(LDAP * ld, const char * dn, LDAPMod * attrs [], LDAPControl * sctrls [], LDAPControl * cctrls [], int * msgidp)"<Bar>echoh None<cr>
inorea ldap_add_ext_s	ldap_add_ext_s<c-o>:echoh HintHL<Bar>echo "int ldap_add_ext_s(LDAP * ld, const char * dn, LDAPMod * attrs [], LDAPControl * sctrls [], LDAPControl * cctrls [])"<Bar>echoh None<cr>
inorea ldap_add	ldap_add<c-o>:echoh HintHL<Bar>echo "int ldap_add(LDAP * ld, const char * dn, LDAPMod * attrs [])"<Bar>echoh None<cr>
inorea ldap_add_s	ldap_add_s<c-o>:echoh HintHL<Bar>echo "int ldap_add_s(LDAP * ld, const char * dn, LDAPMod * attrs [])"<Bar>echoh None<cr>
inorea ldap_attributetype2name	ldap_attributetype2name<c-o>:echoh HintHL<Bar>echo "const char * ldap_attributetype2name(at)"<Bar>echoh None<cr>
inorea ldap_attributetype2str	ldap_attributetype2str<c-o>:echoh HintHL<Bar>echo "char * ldap_attributetype2str(at)"<Bar>echoh None<cr>
inorea ldap_attributetype_free	ldap_attributetype_free<c-o>:echoh HintHL<Bar>echo "ldap_attributetype_free(at)"<Bar>echoh None<cr>
inorea ldap_bind	ldap_bind<c-o>:echoh HintHL<Bar>echo "int ldap_bind(LDAP * ld, const char * who, const char * cred, int method)"<Bar>echoh None<cr>
inorea ldap_bind_s	ldap_bind_s<c-o>:echoh HintHL<Bar>echo "int ldap_bind_s(LDAP * ld, const char * who, const char * cred, int method)"<Bar>echoh None<cr>
inorea ldap_compare	ldap_compare<c-o>:echoh HintHL<Bar>echo "int ldap_compare(ld, dn, attr, value)"<Bar>echoh None<cr>
inorea ldap_compare_s	ldap_compare_s<c-o>:echoh HintHL<Bar>echo "int ldap_compare_s(ld, dn, attr, value)"<Bar>echoh None<cr>
inorea ldap_count_entries	ldap_count_entries<c-o>:echoh HintHL<Bar>echo "int ldap_count_entries( LDAP *ld, LDAPMessage *result)"<Bar>echoh None<cr>
inorea ldap_count_messages	ldap_count_messages<c-o>:echoh HintHL<Bar>echo "int ldap_count_messages( LDAP *ld, LDAPMessage *result)"<Bar>echoh None<cr>
inorea ldap_count_references	ldap_count_references<c-o>:echoh HintHL<Bar>echo "int ldap_count_references( LDAP *ld, LDAPMessage *result)"<Bar>echoh None<cr>
inorea ldap_count_values	ldap_count_values<c-o>:echoh HintHL<Bar>echo "ldap_count_values(vals)"<Bar>echoh None<cr>
inorea ldap_count_values_len	ldap_count_values_len<c-o>:echoh HintHL<Bar>echo "ldap_count_values_len(vals)"<Bar>echoh None<cr>
inorea ldap_dcedn2dn	ldap_dcedn2dn<c-o>:echoh HintHL<Bar>echo "char *ldap_dcedn2dn( const char * dn)"<Bar>echoh None<cr>
inorea ldap_delete	ldap_delete<c-o>:echoh HintHL<Bar>echo "int ldap_delete(ld, dn)"<Bar>echoh None<cr>
inorea ldap_delete_s	ldap_delete_s<c-o>:echoh HintHL<Bar>echo "int ldap_delete_s(ld, dn)"<Bar>echoh None<cr>
inorea ldap_dn2ad_canonical	ldap_dn2ad_canonical<c-o>:echoh HintHL<Bar>echo "char *ldap_dn2ad_canonical( const char * dn)"<Bar>echoh None<cr>
inorea ldap_dn2dcedn	ldap_dn2dcedn<c-o>:echoh HintHL<Bar>echo "char *ldap_dn2dcedn( const char * dn)"<Bar>echoh None<cr>
inorea ldap_dn2str	ldap_dn2str<c-o>:echoh HintHL<Bar>echo "int ldap_dn2str( LDAPDN *dn, char **str, unsigned flags)"<Bar>echoh None<cr>
inorea ldap_dn2ufn	ldap_dn2ufn<c-o>:echoh HintHL<Bar>echo "char *ldap_dn2ufn( const char * dn)"<Bar>echoh None<cr>
inorea ldap_err2string	ldap_err2string<c-o>:echoh HintHL<Bar>echo "char *ldap_err2string( int err)"<Bar>echoh None<cr>
inorea ldap_explode_dn	ldap_explode_dn<c-o>:echoh HintHL<Bar>echo "char **ldap_explode_dn( const char *dn, int notypes)"<Bar>echoh None<cr>
inorea ldap_explode_rdn	ldap_explode_rdn<c-o>:echoh HintHL<Bar>echo "char **ldap_explode_rdn( const char *rdn, int notypes)"<Bar>echoh None<cr>
inorea ldap_first_entry	ldap_first_entry<c-o>:echoh HintHL<Bar>echo "LDAPMessage *ldap_first_entry( LDAP *ld, LDAPMessage *result)"<Bar>echoh None<cr>
inorea ldap_first_message	ldap_first_message<c-o>:echoh HintHL<Bar>echo "LDAPMessage *ldap_first_message( LDAP *ld, LDAPMessage *result)"<Bar>echoh None<cr>
inorea ldap_first_reference	ldap_first_reference<c-o>:echoh HintHL<Bar>echo "LDAPMessage *ldap_first_reference( LDAP *ld, LDAPMessage *result)"<Bar>echoh None<cr>
inorea ldap_free_urldesc	ldap_free_urldesc<c-o>:echoh HintHL<Bar>echo "ldap_free_urldesc( LDAPURLDesc *ludp)"<Bar>echoh None<cr>
inorea ldap_get_dn	ldap_get_dn<c-o>:echoh HintHL<Bar>echo "char *ldap_get_dn( LDAP *ld, LDAPMessage *entry)"<Bar>echoh None<cr>
inorea ldap_get_values	ldap_get_values<c-o>:echoh HintHL<Bar>echo "char **ldap_get_values(ld, entry, attr)"<Bar>echoh None<cr>
inorea ldap_get_values_len	ldap_get_values_len<c-o>:echoh HintHL<Bar>echo "struct berval **ldap_get_values_len(ld, entry, attr)"<Bar>echoh None<cr>
inorea ldap_init	ldap_init<c-o>:echoh HintHL<Bar>echo "LDAP *ldap_init(host, port)"<Bar>echoh None<cr>
inorea ldap_is_ldap_url	ldap_is_ldap_url<c-o>:echoh HintHL<Bar>echo "int ldap_is_ldap_url( const char *url)"<Bar>echoh None<cr>
inorea ldap_matchingrule2name	ldap_matchingrule2name<c-o>:echoh HintHL<Bar>echo "const char * ldap_matchingrule2name(mr)"<Bar>echoh None<cr>
inorea ldap_matchingrule2str	ldap_matchingrule2str<c-o>:echoh HintHL<Bar>echo "char * ldap_matchingrule2str(mr)"<Bar>echoh None<cr>
inorea ldap_matchingrule_free	ldap_matchingrule_free<c-o>:echoh HintHL<Bar>echo "ldap_matchingrule_free(mr)"<Bar>echoh None<cr>
inorea ldap_modify	ldap_modify<c-o>:echoh HintHL<Bar>echo "int ldap_modify(ld, dn, mods)"<Bar>echoh None<cr>
inorea ldap_modify_s	ldap_modify_s<c-o>:echoh HintHL<Bar>echo "int ldap_modify_s(ld, dn, mods)"<Bar>echoh None<cr>
inorea ldap_modrdn2	ldap_modrdn2<c-o>:echoh HintHL<Bar>echo "int ldap_modrdn2(ld, dn, newrdn, deleteoldrdn)"<Bar>echoh None<cr>
inorea ldap_modrdn2_s	ldap_modrdn2_s<c-o>:echoh HintHL<Bar>echo "int ldap_modrdn2_s(ld, dn, newrdn, deleteoldrdn)"<Bar>echoh None<cr>
inorea ldap_modrdn	ldap_modrdn<c-o>:echoh HintHL<Bar>echo "int ldap_modrdn(ld, dn, newrdn)"<Bar>echoh None<cr>
inorea ldap_modrdn_s	ldap_modrdn_s<c-o>:echoh HintHL<Bar>echo "int ldap_modrdn_s(ld, dn, newrdn)"<Bar>echoh None<cr>
inorea ldap_mods_free	ldap_mods_free<c-o>:echoh HintHL<Bar>echo "void ldap_mods_free( mods, freemods)"<Bar>echoh None<cr>
inorea ldap_msgfree	ldap_msgfree<c-o>:echoh HintHL<Bar>echo "int ldap_msgfree( LDAPMessage *msg)"<Bar>echoh None<cr>
inorea ldap_msgid	ldap_msgid<c-o>:echoh HintHL<Bar>echo "int ldap_msgid( LDAPMessage *msg)"<Bar>echoh None<cr>
inorea ldap_msgtype	ldap_msgtype<c-o>:echoh HintHL<Bar>echo "int ldap_msgtype( LDAPMessage *msg)"<Bar>echoh None<cr>
inorea ldap_next_entry	ldap_next_entry<c-o>:echoh HintHL<Bar>echo "LDAPMessage *ldap_next_entry( LDAP *ld, LDAPMessage *entry)"<Bar>echoh None<cr>
inorea ldap_next_message	ldap_next_message<c-o>:echoh HintHL<Bar>echo "LDAPMessage *ldap_next_message( LDAP *ld, LDAPMessage *message)"<Bar>echoh None<cr>
inorea ldap_next_reference	ldap_next_reference<c-o>:echoh HintHL<Bar>echo "LDAPMessage *ldap_next_reference( LDAP *ld, LDAPMessage *reference)"<Bar>echoh None<cr>
inorea ldap_objectclass2name	ldap_objectclass2name<c-o>:echoh HintHL<Bar>echo "const char * ldap_objectclass2name(oc)"<Bar>echoh None<cr>
inorea ldap_objectclass2str	ldap_objectclass2str<c-o>:echoh HintHL<Bar>echo "char * ldap_objectclass2str(oc)"<Bar>echoh None<cr>
inorea ldap_objectclass_free	ldap_objectclass_free<c-o>:echoh HintHL<Bar>echo "ldap_objectclass_free(oc)"<Bar>echoh None<cr>
inorea ldap_open	ldap_open<c-o>:echoh HintHL<Bar>echo "LDAP *ldap_open(host, port)"<Bar>echoh None<cr>
inorea ldap_parse_extended_result	ldap_parse_extended_result<c-o>:echoh HintHL<Bar>echo "int ldap_parse_extended_result( LDAP *ld, LDAPMessage *result, char **retoidp, struct berval **retdatap, int freeit)"<Bar>echoh None<cr>
inorea ldap_parse_reference	ldap_parse_reference<c-o>:echoh HintHL<Bar>echo "int ldap_parse_reference( LDAP *ld, LDAPMessage *reference, char ***referralsp, LDAPControl ***serverctrlsp, int freeit)"<Bar>echoh None<cr>
inorea ldap_parse_result	ldap_parse_result<c-o>:echoh HintHL<Bar>echo "int ldap_parse_result( LDAP *ld, LDAPMessage *result, int *errcodep, char **matcheddnp, char **errmsgp, char ***referralsp, LDAPControl ***serverctrlsp, int freeit)"<Bar>echoh None<cr>
inorea ldap_parse_sasl_bind_result	ldap_parse_sasl_bind_result<c-o>:echoh HintHL<Bar>echo "int ldap_parse_sasl_bind_result(LDAP * ld, LDAPMessage * res, struct berval ** servercredp, int freeit)"<Bar>echoh None<cr>
inorea ldap_parse_sasl_bind_result	ldap_parse_sasl_bind_result<c-o>:echoh HintHL<Bar>echo "int ldap_parse_sasl_bind_result( LDAP *ld, LDAPMessage *result, struct berval **servercredp, int freeit)"<Bar>echoh None<cr>
inorea ldap_perror	ldap_perror<c-o>:echoh HintHL<Bar>echo "void ldap_perror( LDAP *ld, const char *s)"<Bar>echoh None<cr>
inorea ldap_result2error	ldap_result2error<c-o>:echoh HintHL<Bar>echo "int ldap_result2error( LDAP *ld, LDAPMessage *res, int freeit)"<Bar>echoh None<cr>
inorea ldap_result	ldap_result<c-o>:echoh HintHL<Bar>echo "int ldap_result( LDAP *ld, int msgid, int all, struct timeval *timeout, LDAPMessage **result)"<Bar>echoh None<cr>
inorea ldap_sasl_bind	ldap_sasl_bind<c-o>:echoh HintHL<Bar>echo "int ldap_sasl_bind(LDAP * ld, const char * dn, const char * mechanism, struct berval * cred, LDAPControl * sctrls [], LDAPControl * cctrls [], int * msgidp)"<Bar>echoh None<cr>
inorea ldap_sasl_bind_s	ldap_sasl_bind_s<c-o>:echoh HintHL<Bar>echo "int ldap_sasl_bind_s(LDAP * ld, const char * dn, const char * mechanism, struct berval * cred, LDAPControl * sctrls [], LDAPControl * cctrls [], struct berval ** servercredp)"<Bar>echoh None<cr>
inorea ldap_sasl_interactive_bind_s	ldap_sasl_interactive_bind_s<c-o>:echoh HintHL<Bar>echo "int ldap_sasl_interactive_bind_s(LDAP * ld, const char * dn, const char * mechs, LDAPControl * sctrls [], LDAPControl * cctrls [], unsigned flags, LDAP_SASL_INTERACT_PROC * interact, void * defaults)"<Bar>echoh None<cr>
inorea ldap_scherr2str	ldap_scherr2str<c-o>:echoh HintHL<Bar>echo "char * ldap_scherr2str(code)"<Bar>echoh None<cr>
inorea ldap_search	ldap_search<c-o>:echoh HintHL<Bar>echo "int ldap_search(ld, base, scope, filter, attrs, attrsonly)"<Bar>echoh None<cr>
inorea ldap_search_s	ldap_search_s<c-o>:echoh HintHL<Bar>echo "int ldap_search_s(ld, base, scope, filter, attrs, attrsonly, res)"<Bar>echoh None<cr>
inorea ldap_search_st	ldap_search_st<c-o>:echoh HintHL<Bar>echo "int ldap_search_st(ld, base, scope, filter, attrs, attrsonly, timeout, res)"<Bar>echoh None<cr>
inorea ldap_set_rebind_proc	ldap_set_rebind_proc<c-o>:echoh HintHL<Bar>echo "void ldap_set_rebind_proc( ld, rebindproc)"<Bar>echoh None<cr>
inorea ldap_simple_bind	ldap_simple_bind<c-o>:echoh HintHL<Bar>echo "int ldap_simple_bind(LDAP * ld, const char * who, const char * passwd)"<Bar>echoh None<cr>
inorea ldap_simple_bind_s	ldap_simple_bind_s<c-o>:echoh HintHL<Bar>echo "int ldap_simple_bind_s(LDAP * ld, const char * who, const char * passwd)"<Bar>echoh None<cr>
inorea ldap_sort_entries	ldap_sort_entries<c-o>:echoh HintHL<Bar>echo "ldap_sort_entries(ld, chain, attr, cmp)"<Bar>echoh None<cr>
inorea ldap_sort_strcasecmp	ldap_sort_strcasecmp<c-o>:echoh HintHL<Bar>echo "ldap_sort_strcasecmp(a, b)"<Bar>echoh None<cr>
inorea ldap_sort_values	ldap_sort_values<c-o>:echoh HintHL<Bar>echo "ldap_sort_values(ld, vals, cmp)"<Bar>echoh None<cr>
inorea ldap_str2attributetype	ldap_str2attributetype<c-o>:echoh HintHL<Bar>echo "LDAPAttributeType * ldap_str2attributetype(s, code, errp, flags)"<Bar>echoh None<cr>
inorea ldap_str2dn	ldap_str2dn<c-o>:echoh HintHL<Bar>echo "int ldap_str2dn( const char *str, LDAPDN **dn, unsigned flags)"<Bar>echoh None<cr>
inorea ldap_str2matchingrule	ldap_str2matchingrule<c-o>:echoh HintHL<Bar>echo "LDAPMatchingRule * ldap_str2matchingrule(s, code, errp, flags)"<Bar>echoh None<cr>
inorea ldap_str2objectclass	ldap_str2objectclass<c-o>:echoh HintHL<Bar>echo "LDAPObjectClass * ldap_str2objectclass(s, code, errp, flags)"<Bar>echoh None<cr>
inorea ldap_str2syntax	ldap_str2syntax<c-o>:echoh HintHL<Bar>echo "LDAPSyntax * ldap_str2syntax(s, code, errp, flags)"<Bar>echoh None<cr>
inorea ldap_syntax2name	ldap_syntax2name<c-o>:echoh HintHL<Bar>echo "const char * ldap_syntax2name(syn)"<Bar>echoh None<cr>
inorea ldap_syntax2str	ldap_syntax2str<c-o>:echoh HintHL<Bar>echo "char * ldap_syntax2str(syn)"<Bar>echoh None<cr>
inorea ldap_syntax_free	ldap_syntax_free<c-o>:echoh HintHL<Bar>echo "ldap_syntax_free(syn)"<Bar>echoh None<cr>
inorea ldap_unbind	ldap_unbind<c-o>:echoh HintHL<Bar>echo "int ldap_unbind(LDAP * ld)"<Bar>echoh None<cr>
inorea ldap_unbind_s	ldap_unbind_s<c-o>:echoh HintHL<Bar>echo "int ldap_unbind_s(LDAP * ld)"<Bar>echoh None<cr>
inorea ldap_url_parse	ldap_url_parse<c-o>:echoh HintHL<Bar>echo "int ldap_url_parse( const char *url, LDAPURLDesc **ludpp)"<Bar>echoh None<cr>
inorea ldap_value_free	ldap_value_free<c-o>:echoh HintHL<Bar>echo "ldap_value_free(vals)"<Bar>echoh None<cr>
inorea ldap_value_free_len	ldap_value_free_len<c-o>:echoh HintHL<Bar>echo "ldap_value_free_len(vals)"<Bar>echoh None<cr>
inorea ldexpf	ldexpf<c-o>:echoh HintHL<Bar>echo "float ldexpf(float x, int exp)"<Bar>echoh None<cr>
inorea ldexp	ldexp<c-o>:echoh HintHL<Bar>echo "double ldexp(double x, int exp)"<Bar>echoh None<cr>
inorea ldexpl	ldexpl<c-o>:echoh HintHL<Bar>echo "long double ldexpl(long double x, int exp)"<Bar>echoh None<cr>
inorea ldiv	ldiv<c-o>:echoh HintHL<Bar>echo "ldiv_t ldiv(long numerator, long denominator)"<Bar>echoh None<cr>
inorea leaveok	leaveok<c-o>:echoh HintHL<Bar>echo "int leaveok(WINDOW *win, bool bf)"<Bar>echoh None<cr>
inorea lfind	lfind<c-o>:echoh HintHL<Bar>echo "void *lfind(const void * key, const void * base, size_t * nmemb, size_t size, int(* compar)(const void *, const void *))"<Bar>echoh None<cr>
inorea lgammaf	lgammaf<c-o>:echoh HintHL<Bar>echo "float lgammaf(float x)"<Bar>echoh None<cr>
inorea lgammaf_r	lgammaf_r<c-o>:echoh HintHL<Bar>echo "float lgammaf_r(float x, int * signp)"<Bar>echoh None<cr>
inorea lgamma	lgamma<c-o>:echoh HintHL<Bar>echo "double lgamma(double x)"<Bar>echoh None<cr>
inorea lgammal	lgammal<c-o>:echoh HintHL<Bar>echo "long double lgammal(long double x)"<Bar>echoh None<cr>
inorea lgammal_r	lgammal_r<c-o>:echoh HintHL<Bar>echo "long double lgammal_r(long double x, int * signp)"<Bar>echoh None<cr>
inorea lgamma_r	lgamma_r<c-o>:echoh HintHL<Bar>echo "double lgamma_r(double x, int * signp)"<Bar>echoh None<cr>
inorea lgetfilecon	lgetfilecon<c-o>:echoh HintHL<Bar>echo "int lgetfilecon(const char * path, security_context_t * con)"<Bar>echoh None<cr>
inorea link_field	link_field<c-o>:echoh HintHL<Bar>echo "FIELD *link_field(FIELD *field, int toprow, int leftcol)"<Bar>echoh None<cr>
inorea link_fieldtype	link_fieldtype<c-o>:echoh HintHL<Bar>echo "FIELDTYPE *link_fieldtype(FIELDTYPE *type1, FIELDTYPE *type2)"<Bar>echoh None<cr>
inorea llabs	llabs<c-o>:echoh HintHL<Bar>echo "long long int llabs(long long int j)"<Bar>echoh None<cr>
inorea lldiv	lldiv<c-o>:echoh HintHL<Bar>echo "lldiv_t lldiv(long long numerator, long long denominator)"<Bar>echoh None<cr>
inorea llrintf	llrintf<c-o>:echoh HintHL<Bar>echo "long long int llrintf(float x)"<Bar>echoh None<cr>
inorea llrintl	llrintl<c-o>:echoh HintHL<Bar>echo "long long int llrintl(long double x)"<Bar>echoh None<cr>
inorea llrint	llrint<c-o>:echoh HintHL<Bar>echo "long long int llrint(double x)"<Bar>echoh None<cr>
inorea llroundf	llroundf<c-o>:echoh HintHL<Bar>echo "long long int llroundf(float x)"<Bar>echoh None<cr>
inorea llroundl	llroundl<c-o>:echoh HintHL<Bar>echo "long long int llroundl(long double x)"<Bar>echoh None<cr>
inorea llround	llround<c-o>:echoh HintHL<Bar>echo "long long int llround(double x)"<Bar>echoh None<cr>
inorea localeconv	localeconv<c-o>:echoh HintHL<Bar>echo "struct lconv *localeconv(void)"<Bar>echoh None<cr>
inorea localtime	localtime<c-o>:echoh HintHL<Bar>echo "struct tm *localtime(const time_t * timep)"<Bar>echoh None<cr>
inorea localtime_r	localtime_r<c-o>:echoh HintHL<Bar>echo "struct tm *localtime_r(const time_t * timep, struct tm * result)"<Bar>echoh None<cr>
inorea lockf	lockf<c-o>:echoh HintHL<Bar>echo "int lockf(int fd, int cmd, off_t len)"<Bar>echoh None<cr>
inorea log10f	log10f<c-o>:echoh HintHL<Bar>echo "float log10f(float x)"<Bar>echoh None<cr>
inorea log10l	log10l<c-o>:echoh HintHL<Bar>echo "long double log10l(long double x)"<Bar>echoh None<cr>
inorea log10	log10<c-o>:echoh HintHL<Bar>echo "double log10(double x)"<Bar>echoh None<cr>
inorea log1pf	log1pf<c-o>:echoh HintHL<Bar>echo "float log1pf(float x)"<Bar>echoh None<cr>
inorea log1pl	log1pl<c-o>:echoh HintHL<Bar>echo "long double log1pl(long double x)"<Bar>echoh None<cr>
inorea log1p	log1p<c-o>:echoh HintHL<Bar>echo "double log1p(double x)"<Bar>echoh None<cr>
inorea log2f	log2f<c-o>:echoh HintHL<Bar>echo "float log2f(float x)"<Bar>echoh None<cr>
inorea log2l	log2l<c-o>:echoh HintHL<Bar>echo "long double log2l(long double x)"<Bar>echoh None<cr>
inorea log2	log2<c-o>:echoh HintHL<Bar>echo "double log2(double x)"<Bar>echoh None<cr>
inorea logbf	logbf<c-o>:echoh HintHL<Bar>echo "float logbf(float x)"<Bar>echoh None<cr>
inorea logbl	logbl<c-o>:echoh HintHL<Bar>echo "long double logbl(long double x)"<Bar>echoh None<cr>
inorea logb	logb<c-o>:echoh HintHL<Bar>echo "double logb(double x)"<Bar>echoh None<cr>
inorea logf	logf<c-o>:echoh HintHL<Bar>echo "float logf(float x)"<Bar>echoh None<cr>
inorea login	login<c-o>:echoh HintHL<Bar>echo "void login(const struct utmp * ut)"<Bar>echoh None<cr>
inorea login_tty	login_tty<c-o>:echoh HintHL<Bar>echo "int login_tty(int fd)"<Bar>echoh None<cr>
inorea logl	logl<c-o>:echoh HintHL<Bar>echo "long double logl(long double x)"<Bar>echoh None<cr>
inorea log	log<c-o>:echoh HintHL<Bar>echo "double log(double x)"<Bar>echoh None<cr>
inorea logout	logout<c-o>:echoh HintHL<Bar>echo "int logout(const char * ut_line)"<Bar>echoh None<cr>
inorea logwtmp	logwtmp<c-o>:echoh HintHL<Bar>echo "void logwtmp(const char * line, const char * name, const char * host)"<Bar>echoh None<cr>
inorea longjmp	longjmp<c-o>:echoh HintHL<Bar>echo "void longjmp(jmp_buf env, int val)"<Bar>echoh None<cr>
inorea longname	longname<c-o>:echoh HintHL<Bar>echo "char *longname(void)"<Bar>echoh None<cr>
inorea lrand48	lrand48<c-o>:echoh HintHL<Bar>echo "long int lrand48(void)"<Bar>echoh None<cr>
inorea lrand48_r	lrand48_r<c-o>:echoh HintHL<Bar>echo "int lrand48_r(struct drand48_data * buffer, long int * result)"<Bar>echoh None<cr>
inorea lrintf	lrintf<c-o>:echoh HintHL<Bar>echo "long int lrintf(float x)"<Bar>echoh None<cr>
inorea lrintl	lrintl<c-o>:echoh HintHL<Bar>echo "long int lrintl(long double x)"<Bar>echoh None<cr>
inorea lrint	lrint<c-o>:echoh HintHL<Bar>echo "long int lrint(double x)"<Bar>echoh None<cr>
inorea lroundf	lroundf<c-o>:echoh HintHL<Bar>echo "long int lroundf(float x)"<Bar>echoh None<cr>
inorea lroundl	lroundl<c-o>:echoh HintHL<Bar>echo "long int lroundl(long double x)"<Bar>echoh None<cr>
inorea lround	lround<c-o>:echoh HintHL<Bar>echo "long int lround(double x)"<Bar>echoh None<cr>
inorea lsearch	lsearch<c-o>:echoh HintHL<Bar>echo "void *lsearch(const void * key, void * base, size_t * nmemb, size_t size, int(* compar)(const void *, const void *))"<Bar>echoh None<cr>
inorea lseek64	lseek64<c-o>:echoh HintHL<Bar>echo "off64_t lseek64(int fd, off64_t offset, int whence)"<Bar>echoh None<cr>
inorea lsetfilecon	lsetfilecon<c-o>:echoh HintHL<Bar>echo "int lsetfilecon(const char * path, security_context_t con)"<Bar>echoh None<cr>
inorea makecontext	makecontext<c-o>:echoh HintHL<Bar>echo "void makecontext(ucontext_t * ucp, void * func (), int argc, ...)"<Bar>echoh None<cr>
inorea malloc	malloc<c-o>:echoh HintHL<Bar>echo "void * malloc (size_t size)"<Bar>echoh None<cr>
inorea malloc	malloc<c-o>:echoh HintHL<Bar>echo "void *malloc(size_t size)"<Bar>echoh None<cr>
inorea manual_user_enter_context	manual_user_enter_context<c-o>:echoh HintHL<Bar>echo "int manual_user_enter_context(const char * user, security_context_t * newcon)"<Bar>echoh None<cr>
inorea matchmediacon	matchmediacon<c-o>:echoh HintHL<Bar>echo "int matchmediacon(const char * media, security_context_t * con)"<Bar>echoh None<cr>
inorea matchpathcon_fini	matchpathcon_fini<c-o>:echoh HintHL<Bar>echo "int matchpathcon_fini(void)"<Bar>echoh None<cr>
inorea matchpathcon_init	matchpathcon_init<c-o>:echoh HintHL<Bar>echo "int matchpathcon_init(const char * path)"<Bar>echoh None<cr>
inorea matchpathcon	matchpathcon<c-o>:echoh HintHL<Bar>echo "int matchpathcon(const char * path, mode_t mode, security_context_t * con)"<Bar>echoh None<cr>
inorea mblen	mblen<c-o>:echoh HintHL<Bar>echo "int mblen(const char * s, size_t n)"<Bar>echoh None<cr>
inorea mbrlen	mbrlen<c-o>:echoh HintHL<Bar>echo "size_t mbrlen(const char * s, size_t n, mbstate_t * ps)"<Bar>echoh None<cr>
inorea mbrtowc	mbrtowc<c-o>:echoh HintHL<Bar>echo "size_t mbrtowc(wchar_t * pwc, const char * s, size_t n, mbstate_t * ps)"<Bar>echoh None<cr>
inorea mbsinit	mbsinit<c-o>:echoh HintHL<Bar>echo "int mbsinit(const mbstate_t * ps)"<Bar>echoh None<cr>
inorea mbsnrtowcs	mbsnrtowcs<c-o>:echoh HintHL<Bar>echo "size_t mbsnrtowcs(wchar_t * dest, const char ** src, size_t nms, size_t len, mbstate_t * ps)"<Bar>echoh None<cr>
inorea mbsrtowcs	mbsrtowcs<c-o>:echoh HintHL<Bar>echo "size_t mbsrtowcs(wchar_t * dest, const char ** src, size_t len, mbstate_t * ps)"<Bar>echoh None<cr>
inorea mbstowcs	mbstowcs<c-o>:echoh HintHL<Bar>echo "size_t mbstowcs(wchar_t * dest, const char * src, size_t n)"<Bar>echoh None<cr>
inorea mbtowc	mbtowc<c-o>:echoh HintHL<Bar>echo "int mbtowc(wchar_t * pwc, const char * s, size_t n)"<Bar>echoh None<cr>
inorea mcprint	mcprint<c-o>:echoh HintHL<Bar>echo "int mcprint(char *data, int len)"<Bar>echoh None<cr>
inorea memalign	memalign<c-o>:echoh HintHL<Bar>echo "void * memalign (size_t alignment, size_t size)"<Bar>echoh None<cr>
inorea memalign	memalign<c-o>:echoh HintHL<Bar>echo "void *memalign(size_t boundary, size_t size)"<Bar>echoh None<cr>
inorea memccpy	memccpy<c-o>:echoh HintHL<Bar>echo "void *memccpy(void * dest, const void * src, int c, size_t n)"<Bar>echoh None<cr>
inorea memchr	memchr<c-o>:echoh HintHL<Bar>echo "void *memchr(const void * s, int c, size_t n)"<Bar>echoh None<cr>
inorea memcmp	memcmp<c-o>:echoh HintHL<Bar>echo "int memcmp(const void * s1, const void * s2, size_t n)"<Bar>echoh None<cr>
inorea memcpy	memcpy<c-o>:echoh HintHL<Bar>echo "void *memcpy(void * dest, const void * src, size_t n)"<Bar>echoh None<cr>
inorea memfrob	memfrob<c-o>:echoh HintHL<Bar>echo "void *memfrob(void * s, size_t n)"<Bar>echoh None<cr>
inorea memmem	memmem<c-o>:echoh HintHL<Bar>echo "void *memmem(const void * needle, size_t needlelen, const void * haystack, size_t haystacklen)"<Bar>echoh None<cr>
inorea memmove	memmove<c-o>:echoh HintHL<Bar>echo "void *memmove(void * dest, const void * src, size_t n)"<Bar>echoh None<cr>
inorea mempcpy	mempcpy<c-o>:echoh HintHL<Bar>echo "void *mempcpy(void * dest, const void * src, size_t n)"<Bar>echoh None<cr>
inorea memrchr	memrchr<c-o>:echoh HintHL<Bar>echo "void *memrchr(const void * s, int c, size_t n)"<Bar>echoh None<cr>
inorea memset	memset<c-o>:echoh HintHL<Bar>echo "void *memset(void * s, int c, size_t n)"<Bar>echoh None<cr>
inorea menu_back	menu_back<c-o>:echoh HintHL<Bar>echo "chtype menu_back(const MENU *menu)"<Bar>echoh None<cr>
inorea menu_driver	menu_driver<c-o>:echoh HintHL<Bar>echo "int menu_driver(MENU *menu, int c)"<Bar>echoh None<cr>
inorea menu_fore	menu_fore<c-o>:echoh HintHL<Bar>echo "chtype menu_fore(const MENU *menu)"<Bar>echoh None<cr>
inorea menu_format	menu_format<c-o>:echoh HintHL<Bar>echo "void menu_format(const MENU *menu, int *rows, int *cols)"<Bar>echoh None<cr>
inorea menu_grey	menu_grey<c-o>:echoh HintHL<Bar>echo "chtype menu_grey(const MENU *menu)"<Bar>echoh None<cr>
inorea menu_items	menu_items<c-o>:echoh HintHL<Bar>echo "ITEM **menu_items(const MENU *menu)"<Bar>echoh None<cr>
inorea menu_mark	menu_mark<c-o>:echoh HintHL<Bar>echo "const char *menu_mark(const MENU *menu)"<Bar>echoh None<cr>
inorea menu_opts	menu_opts<c-o>:echoh HintHL<Bar>echo "OPTIONS menu_opts(const MENU *menu)"<Bar>echoh None<cr>
inorea menu_opts_off	menu_opts_off<c-o>:echoh HintHL<Bar>echo "int menu_opts_off(MENU *menu, OPTIONS opts)"<Bar>echoh None<cr>
inorea menu_opts_on	menu_opts_on<c-o>:echoh HintHL<Bar>echo "int menu_opts_on(MENU *menu, OPTIONS opts)"<Bar>echoh None<cr>
inorea menu_pad	menu_pad<c-o>:echoh HintHL<Bar>echo "int menu_pad(const MENU *menu)"<Bar>echoh None<cr>
inorea menu_pattern	menu_pattern<c-o>:echoh HintHL<Bar>echo "char *menu_pattern(const MENU *menu)"<Bar>echoh None<cr>
inorea menu_request_by_name	menu_request_by_name<c-o>:echoh HintHL<Bar>echo "int menu_request_by_name(const char *name)"<Bar>echoh None<cr>
inorea menu_request_name	menu_request_name<c-o>:echoh HintHL<Bar>echo "const char *menu_request_name(int request)"<Bar>echoh None<cr>
inorea menu_spacing	menu_spacing<c-o>:echoh HintHL<Bar>echo "int menu_spacing(const MENU *menu, int* spc_description, int* spc_rows, int* spc_columns)"<Bar>echoh None<cr>
inorea menu_sub	menu_sub<c-o>:echoh HintHL<Bar>echo "WINDOW *menu_sub(const MENU *menu)"<Bar>echoh None<cr>
inorea menu_userptr	menu_userptr<c-o>:echoh HintHL<Bar>echo "void *menu_userptr(const MENU *menu)"<Bar>echoh None<cr>
inorea menu_win	menu_win<c-o>:echoh HintHL<Bar>echo "WINDOW *menu_win(const MENU *menu)"<Bar>echoh None<cr>
inorea meta	meta<c-o>:echoh HintHL<Bar>echo "int meta(WINDOW *win, bool bf)"<Bar>echoh None<cr>
inorea misc_conv	misc_conv<c-o>:echoh HintHL<Bar>echo "void misc_conv(intnum_msg, conststructpam_message** msgm, structpam_response** response, void* appdata_ptr)"<Bar>echoh None<cr>
inorea mkdtemp	mkdtemp<c-o>:echoh HintHL<Bar>echo "char *mkdtemp(char * template)"<Bar>echoh None<cr>
inorea mkfifo	mkfifo<c-o>:echoh HintHL<Bar>echo "int mkfifo(const char * pathname, mode_t mode)"<Bar>echoh None<cr>
inorea mkstemp	mkstemp<c-o>:echoh HintHL<Bar>echo "int mkstemp(char * template)"<Bar>echoh None<cr>
inorea mktemp	mktemp<c-o>:echoh HintHL<Bar>echo "char *mktemp(char * template)"<Bar>echoh None<cr>
inorea mktime	mktime<c-o>:echoh HintHL<Bar>echo "time_t mktime(struct tm * tm)"<Bar>echoh None<cr>
inorea modff	modff<c-o>:echoh HintHL<Bar>echo "float modff(float x, float * iptr)"<Bar>echoh None<cr>
inorea modfl	modfl<c-o>:echoh HintHL<Bar>echo "long double modfl(long double x, long double * iptr)"<Bar>echoh None<cr>
inorea modf	modf<c-o>:echoh HintHL<Bar>echo "double modf(double x, double * iptr)"<Bar>echoh None<cr>
inorea mostly	mostly<c-o>:echoh HintHL<Bar>echo "If you're already used to \s-1CPAN\s0.pm you're welcome to continue using it, if you accept that its development is mostly (though not completely)"<Bar>echoh None<cr>
inorea mouseinterval	mouseinterval<c-o>:echoh HintHL<Bar>echo "int mouseinterval(int erval)"<Bar>echoh None<cr>
inorea mousemask	mousemask<c-o>:echoh HintHL<Bar>echo "mmask_t mousemask(mmask_t newmask, mmask_t *oldmask)"<Bar>echoh None<cr>
inorea mouse_trafo	mouse_trafo<c-o>:echoh HintHL<Bar>echo "bool mouse_trafo(int* pY, int* pX, bool to_screen)"<Bar>echoh None<cr>
inorea move_field	move_field<c-o>:echoh HintHL<Bar>echo "int move_field(FIELD *field, int frow, int fcol)"<Bar>echoh None<cr>
inorea move	move<c-o>:echoh HintHL<Bar>echo "int move(int y, int x)"<Bar>echoh None<cr>
inorea move_panel	move_panel<c-o>:echoh HintHL<Bar>echo "int move_panel(PANEL *pan, int starty, int startx)"<Bar>echoh None<cr>
inorea mpool_close	mpool_close<c-o>:echoh HintHL<Bar>echo "mpool_close (MPOOL *mp)"<Bar>echoh None<cr>
inorea mpool_get	mpool_get<c-o>:echoh HintHL<Bar>echo "mpool_get (MPOOL *mp, pgno_t pgno, u_int flags)"<Bar>echoh None<cr>
inorea mpool_new	mpool_new<c-o>:echoh HintHL<Bar>echo "mpool_new (MPOOL *mp, pgno_t *pgnoaddr)"<Bar>echoh None<cr>
inorea mpool_open	mpool_open<c-o>:echoh HintHL<Bar>echo "mpool_open (DBT *key, int fd, pgno_t pagesize, pgno_t maxcache)"<Bar>echoh None<cr>
inorea mpool_put	mpool_put<c-o>:echoh HintHL<Bar>echo "mpool_put (MPOOL *mp, void *pgaddr, u_int flags)"<Bar>echoh None<cr>
inorea mpool_sync	mpool_sync<c-o>:echoh HintHL<Bar>echo "mpool_sync (MPOOL *mp)"<Bar>echoh None<cr>
inorea mrand48	mrand48<c-o>:echoh HintHL<Bar>echo "long int mrand48(void)"<Bar>echoh None<cr>
inorea mrand48_r	mrand48_r<c-o>:echoh HintHL<Bar>echo "int mrand48_r(struct drand48_data * buffer, long int * result)"<Bar>echoh None<cr>
inorea mtrace	mtrace<c-o>:echoh HintHL<Bar>echo "void mtrace(void)"<Bar>echoh None<cr>
inorea muntrace	muntrace<c-o>:echoh HintHL<Bar>echo "void muntrace(void)"<Bar>echoh None<cr>
inorea mvaddch	mvaddch<c-o>:echoh HintHL<Bar>echo "int mvaddch(int y, int x, const chtype ch)"<Bar>echoh None<cr>
inorea mvaddchnstr	mvaddchnstr<c-o>:echoh HintHL<Bar>echo "int mvaddchnstr(int y, int x, const chtype *chstr, int n)"<Bar>echoh None<cr>
inorea mvaddchstr	mvaddchstr<c-o>:echoh HintHL<Bar>echo "int mvaddchstr(int y, int x, const chtype *chstr)"<Bar>echoh None<cr>
inorea mvaddnstr	mvaddnstr<c-o>:echoh HintHL<Bar>echo "int mvaddnstr(int y, int x, const char *str, int n)"<Bar>echoh None<cr>
inorea mvaddnwstr	mvaddnwstr<c-o>:echoh HintHL<Bar>echo "int mvaddnwstr(int y, int x, const wchar_t *wstr, int n)"<Bar>echoh None<cr>
inorea mvaddstr	mvaddstr<c-o>:echoh HintHL<Bar>echo "int mvaddstr(int y, int x, const char *str)"<Bar>echoh None<cr>
inorea mvadd_wch	mvadd_wch<c-o>:echoh HintHL<Bar>echo "int mvadd_wch( int y\fP, int x\fP, const cchar_t *wch)"<Bar>echoh None<cr>
inorea mvadd_wchnstr	mvadd_wchnstr<c-o>:echoh HintHL<Bar>echo "int mvadd_wchnstr(int y, int x, const cchar_t *wchstr, int n)"<Bar>echoh None<cr>
inorea mvadd_wchstr	mvadd_wchstr<c-o>:echoh HintHL<Bar>echo "int mvadd_wchstr(int y, int x, const cchar_t *wchstr)"<Bar>echoh None<cr>
inorea mvaddwstr	mvaddwstr<c-o>:echoh HintHL<Bar>echo "int mvaddwstr(int y, int x, const wchar_t *wstr)"<Bar>echoh None<cr>
inorea mvchgat	mvchgat<c-o>:echoh HintHL<Bar>echo "int mvchgat(int y, int x, int n, attr_t attr, short color, const void *opts)"<Bar>echoh None<cr>
inorea mvcur	mvcur<c-o>:echoh HintHL<Bar>echo "int mvcur(int oldrow, int oldcol, int newrow, int newcol)"<Bar>echoh None<cr>
inorea mvdelch	mvdelch<c-o>:echoh HintHL<Bar>echo "int mvdelch(int y, int x)"<Bar>echoh None<cr>
inorea mvderwin	mvderwin<c-o>:echoh HintHL<Bar>echo "int mvderwin(WINDOW *win, int par_y, int par_x)"<Bar>echoh None<cr>
inorea mvgetch	mvgetch<c-o>:echoh HintHL<Bar>echo "int mvgetch(int y, int x)"<Bar>echoh None<cr>
inorea mvgetnstr	mvgetnstr<c-o>:echoh HintHL<Bar>echo "int mvgetnstr(int y, int x, char *str, int n)"<Bar>echoh None<cr>
inorea mvgetn_wstr	mvgetn_wstr<c-o>:echoh HintHL<Bar>echo "int mvgetn_wstr(int y, int x, wint_t *wstr, int n)"<Bar>echoh None<cr>
inorea mvgetstr	mvgetstr<c-o>:echoh HintHL<Bar>echo "int mvgetstr(int y, int x, char *str)"<Bar>echoh None<cr>
inorea mvget_wch	mvget_wch<c-o>:echoh HintHL<Bar>echo "int mvget_wch(int y, int x, wint_t *wch)"<Bar>echoh None<cr>
inorea mvget_wstr	mvget_wstr<c-o>:echoh HintHL<Bar>echo "int mvget_wstr(int y, int x, wint_t *wstr)"<Bar>echoh None<cr>
inorea mvhline	mvhline<c-o>:echoh HintHL<Bar>echo "mvhline(int y, int x, chtype ch, int n)"<Bar>echoh None<cr>
inorea mvinch	mvinch<c-o>:echoh HintHL<Bar>echo "chtype mvinch(int y, int x)"<Bar>echoh None<cr>
inorea mvinchnstr	mvinchnstr<c-o>:echoh HintHL<Bar>echo "int mvinchnstr(int y, int x, chtype *chstr, int n)"<Bar>echoh None<cr>
inorea mvinchstr	mvinchstr<c-o>:echoh HintHL<Bar>echo "int mvinchstr(int y, int x, chtype *chstr)"<Bar>echoh None<cr>
inorea mvinnstr	mvinnstr<c-o>:echoh HintHL<Bar>echo "int mvinnstr(int y, int x, char *str, int n)"<Bar>echoh None<cr>
inorea mvinnwstr	mvinnwstr<c-o>:echoh HintHL<Bar>echo "int mvinnwstr(int y, int x, wchar_t *str, int n)"<Bar>echoh None<cr>
inorea mvinsch	mvinsch<c-o>:echoh HintHL<Bar>echo "int mvinsch(int y, int x, chtype ch)"<Bar>echoh None<cr>
inorea mvinsnstr	mvinsnstr<c-o>:echoh HintHL<Bar>echo "int mvinsnstr(int y, int x, const char *str, int n)"<Bar>echoh None<cr>
inorea mvins_nwstr	mvins_nwstr<c-o>:echoh HintHL<Bar>echo "int mvins_nwstr(int y, int x, const wchar_t *wstr, int n)"<Bar>echoh None<cr>
inorea mvinsstr	mvinsstr<c-o>:echoh HintHL<Bar>echo "int mvinsstr(int y, int x, const char *str)"<Bar>echoh None<cr>
inorea mvinstr	mvinstr<c-o>:echoh HintHL<Bar>echo "int mvinstr(int y, int x, char *str)"<Bar>echoh None<cr>
inorea mvins_wch	mvins_wch<c-o>:echoh HintHL<Bar>echo "int mvins_wch(int y, int x, const cchar_t *wch)"<Bar>echoh None<cr>
inorea mvins_wstr	mvins_wstr<c-o>:echoh HintHL<Bar>echo "int mvins_wstr(int y, int x, const wchar_t *wstr)"<Bar>echoh None<cr>
inorea mvin_wch	mvin_wch<c-o>:echoh HintHL<Bar>echo "int mvin_wch(int y, int x, cchar_t *wcval)"<Bar>echoh None<cr>
inorea mvin_wchnstr	mvin_wchnstr<c-o>:echoh HintHL<Bar>echo "int mvin_wchnstr(int y, int x, cchar_t *wchstr, int n)"<Bar>echoh None<cr>
inorea mvin_wchstr	mvin_wchstr<c-o>:echoh HintHL<Bar>echo "int mvin_wchstr(int y, int x, cchar_t *wchstr)"<Bar>echoh None<cr>
inorea mvinwstr	mvinwstr<c-o>:echoh HintHL<Bar>echo "int mvinwstr(int y, int x, wchar_t *str)"<Bar>echoh None<cr>
inorea mvprintw	mvprintw<c-o>:echoh HintHL<Bar>echo "int mvprintw(int y, int x, const char *fmt, ...)"<Bar>echoh None<cr>
inorea mvscanw	mvscanw<c-o>:echoh HintHL<Bar>echo "int mvscanw(int y, int x, char *fmt, ...)"<Bar>echoh None<cr>
inorea mvvline	mvvline<c-o>:echoh HintHL<Bar>echo "int mvvline(int y, int x, chtype ch, int n)"<Bar>echoh None<cr>
inorea mvwaddch	mvwaddch<c-o>:echoh HintHL<Bar>echo "int mvwaddch(WINDOW *win, int y, int x, const chtype ch)"<Bar>echoh None<cr>
inorea mvwaddchnstr	mvwaddchnstr<c-o>:echoh HintHL<Bar>echo "int mvwaddchnstr(WINDOW *win, int y, int x, const chtype *chstr, int n)"<Bar>echoh None<cr>
inorea mvwaddchstr	mvwaddchstr<c-o>:echoh HintHL<Bar>echo "int mvwaddchstr(WINDOW *win, int y, int x, const chtype *chstr)"<Bar>echoh None<cr>
inorea mvwaddnstr	mvwaddnstr<c-o>:echoh HintHL<Bar>echo "int mvwaddnstr(WINDOW *win, int y, int x, const char *str, int n)"<Bar>echoh None<cr>
inorea mvwaddnwstr	mvwaddnwstr<c-o>:echoh HintHL<Bar>echo "int mvwaddnwstr(WINDOW *win, int y, int x, const wchar_t *wstr, int n)"<Bar>echoh None<cr>
inorea mvwaddstr	mvwaddstr<c-o>:echoh HintHL<Bar>echo "int mvwaddstr(WINDOW *win, int y, int x, const char *str)"<Bar>echoh None<cr>
inorea mvwadd_wch	mvwadd_wch<c-o>:echoh HintHL<Bar>echo "int mvwadd_wch( WINDOW *win\fP, int y\fP, int x\fP, const cchar_t *wch)"<Bar>echoh None<cr>
inorea mvwadd_wchnstr	mvwadd_wchnstr<c-o>:echoh HintHL<Bar>echo "int mvwadd_wchnstr(WINDOW *win, int y, int x, const cchar_t *wchstr, int n)"<Bar>echoh None<cr>
inorea mvwadd_wchstr	mvwadd_wchstr<c-o>:echoh HintHL<Bar>echo "int mvwadd_wchstr(WINDOW *win, int y, int x, const cchar_t *wchstr)"<Bar>echoh None<cr>
inorea mvwaddwstr	mvwaddwstr<c-o>:echoh HintHL<Bar>echo "int mvwaddwstr(WINDOW *win, int y, int x, const wchar_t *wstr)"<Bar>echoh None<cr>
inorea mvwchgat	mvwchgat<c-o>:echoh HintHL<Bar>echo "int mvwchgat(WINDOW *win, int y, int x, int n, attr_t attr, short color, const void *opts)"<Bar>echoh None<cr>
inorea mvwdelch	mvwdelch<c-o>:echoh HintHL<Bar>echo "int mvwdelch(WINDOW *win, int y, int x)"<Bar>echoh None<cr>
inorea mvwgetch	mvwgetch<c-o>:echoh HintHL<Bar>echo "int mvwgetch(WINDOW *win, int y, int x)"<Bar>echoh None<cr>
inorea mvwgetnstr	mvwgetnstr<c-o>:echoh HintHL<Bar>echo "int mvwgetnstr(WINDOW *, int y, int x, char *str, int n)"<Bar>echoh None<cr>
inorea mvwgetn_wstr	mvwgetn_wstr<c-o>:echoh HintHL<Bar>echo "int mvwgetn_wstr(WINDOW *win, int y, int x, wint_t *wstr, int n)"<Bar>echoh None<cr>
inorea mvwgetstr	mvwgetstr<c-o>:echoh HintHL<Bar>echo "int mvwgetstr(WINDOW *win, int y, int x, char *str)"<Bar>echoh None<cr>
inorea mvwget_wch	mvwget_wch<c-o>:echoh HintHL<Bar>echo "int mvwget_wch(WINDOW *win, int y, int x, wint_t *wch)"<Bar>echoh None<cr>
inorea mvwget_wstr	mvwget_wstr<c-o>:echoh HintHL<Bar>echo "int mvwget_wstr(WINDOW *win, int y, int x, wint_t *wstr)"<Bar>echoh None<cr>
inorea mvwhline	mvwhline<c-o>:echoh HintHL<Bar>echo "mvwhline(WINDOW *, int y, int x, chtype ch, int n)"<Bar>echoh None<cr>
inorea mvwinch	mvwinch<c-o>:echoh HintHL<Bar>echo "chtype mvwinch(WINDOW *win, int y, int x)"<Bar>echoh None<cr>
inorea mvwinchnstr	mvwinchnstr<c-o>:echoh HintHL<Bar>echo "int mvwinchnstr(WINDOW *win, int y, int x, chtype *chstr, int n)"<Bar>echoh None<cr>
inorea mvwinchstr	mvwinchstr<c-o>:echoh HintHL<Bar>echo "int mvwinchstr(WINDOW *win, int y, int x, chtype *chstr)"<Bar>echoh None<cr>
inorea mvwin	mvwin<c-o>:echoh HintHL<Bar>echo "int mvwin(WINDOW *win, int y, int x)"<Bar>echoh None<cr>
inorea mvwinnstr	mvwinnstr<c-o>:echoh HintHL<Bar>echo "int mvwinnstr(WINDOW *win, int y, int x, char *str, int n)"<Bar>echoh None<cr>
inorea mvwinnwstr	mvwinnwstr<c-o>:echoh HintHL<Bar>echo "int mvwinnwstr(WINDOW *win, int y, int x, wchar_t *str, int n)"<Bar>echoh None<cr>
inorea mvwinsch	mvwinsch<c-o>:echoh HintHL<Bar>echo "int mvwinsch(WINDOW *win, int y, int x, chtype ch)"<Bar>echoh None<cr>
inorea mvwinsnstr	mvwinsnstr<c-o>:echoh HintHL<Bar>echo "int mvwinsnstr(WINDOW *win, int y, int x, const char *str, int n)"<Bar>echoh None<cr>
inorea mvwins_nwstr	mvwins_nwstr<c-o>:echoh HintHL<Bar>echo "int mvwins_nwstr(WINDOW *win, int y, int x, const wchar_t *wstr, int n)"<Bar>echoh None<cr>
inorea mvwinsstr	mvwinsstr<c-o>:echoh HintHL<Bar>echo "int mvwinsstr(WINDOW *win, int y, int x, const char *str)"<Bar>echoh None<cr>
inorea mvwinstr	mvwinstr<c-o>:echoh HintHL<Bar>echo "int mvwinstr(WINDOW *win, int y, int x, char *str)"<Bar>echoh None<cr>
inorea mvwins_wch	mvwins_wch<c-o>:echoh HintHL<Bar>echo "int mvwins_wch(WINDOW *win, int y, int x, const cchar_t *wch)"<Bar>echoh None<cr>
inorea mvwins_wstr	mvwins_wstr<c-o>:echoh HintHL<Bar>echo "int mvwins_wstr(WINDOW *win, int y, int x, const wchar_t *wstr)"<Bar>echoh None<cr>
inorea mvwin_wch	mvwin_wch<c-o>:echoh HintHL<Bar>echo "int mvwin_wch(WINDOW *win, int y, int x, cchar_t *wcval)"<Bar>echoh None<cr>
inorea mvwin_wchnstr	mvwin_wchnstr<c-o>:echoh HintHL<Bar>echo "int mvwin_wchnstr(WINDOW *win, int y, int x, cchar_t *wchstr, int n)"<Bar>echoh None<cr>
inorea mvwin_wchstr	mvwin_wchstr<c-o>:echoh HintHL<Bar>echo "int mvwin_wchstr(WINDOW *win, int y, int x, cchar_t *wchstr)"<Bar>echoh None<cr>
inorea mvwinwstr	mvwinwstr<c-o>:echoh HintHL<Bar>echo "int mvwinwstr(WINDOW *win, int y, int x, wchar_t *str)"<Bar>echoh None<cr>
inorea mvwprintw	mvwprintw<c-o>:echoh HintHL<Bar>echo "int mvwprintw(WINDOW *win, int y, int x, const char *fmt, ...)"<Bar>echoh None<cr>
inorea mvwscanw	mvwscanw<c-o>:echoh HintHL<Bar>echo "int mvwscanw(WINDOW *win, int y, int x, char *fmt, ...)"<Bar>echoh None<cr>
inorea mvwvline	mvwvline<c-o>:echoh HintHL<Bar>echo "int mvwvline(WINDOW *, int y, int x, chtype ch, int n)"<Bar>echoh None<cr>
inorea nanf	nanf<c-o>:echoh HintHL<Bar>echo "float nanf(const char * tagp)"<Bar>echoh None<cr>
inorea nanl	nanl<c-o>:echoh HintHL<Bar>echo "long double nanl(const char * tagp)"<Bar>echoh None<cr>
inorea nan	nan<c-o>:echoh HintHL<Bar>echo "double nan(const char * tagp)"<Bar>echoh None<cr>
inorea napms	napms<c-o>:echoh HintHL<Bar>echo "int napms(int ms)"<Bar>echoh None<cr>
inorea _nc_tracebits	_nc_tracebits<c-o>:echoh HintHL<Bar>echo "char *_nc_tracebits(void)"<Bar>echoh None<cr>
inorea ne_addr_error	ne_addr_error<c-o>:echoh HintHL<Bar>echo "char*ne_addr_error(constne_sock_addr*addr, char*buffer, size_tbufsiz)"<Bar>echoh None<cr>
inorea ne_addr_first	ne_addr_first<c-o>:echoh HintHL<Bar>echo "constne_inet_addr*ne_addr_first(ne_sock_addr*addr)"<Bar>echoh None<cr>
inorea ne_addr_next	ne_addr_next<c-o>:echoh HintHL<Bar>echo "constne_inet_addr*ne_addr_next(ne_sock_addr*addr)"<Bar>echoh None<cr>
inorea ne_addr_resolve	ne_addr_resolve<c-o>:echoh HintHL<Bar>echo "ne_sock_addr*ne_addr_resolve(constchar*hostname, intflags)"<Bar>echoh None<cr>
inorea nearbyintf	nearbyintf<c-o>:echoh HintHL<Bar>echo "float nearbyintf(float x)"<Bar>echoh None<cr>
inorea nearbyintl	nearbyintl<c-o>:echoh HintHL<Bar>echo "long double nearbyintl(long double x)"<Bar>echoh None<cr>
inorea nearbyint	nearbyint<c-o>:echoh HintHL<Bar>echo "double nearbyint(double x)"<Bar>echoh None<cr>
inorea ne_buffer_create	ne_buffer_create<c-o>:echoh HintHL<Bar>echo "ne_buffer*ne_buffer_create(void)"<Bar>echoh None<cr>
inorea ne_buffer_finish	ne_buffer_finish<c-o>:echoh HintHL<Bar>echo "char*ne_buffer_finish(ne_buffer*buf)"<Bar>echoh None<cr>
inorea ne_buffer_ncreate	ne_buffer_ncreate<c-o>:echoh HintHL<Bar>echo "ne_buffer*ne_buffer_ncreate(size_tsize)"<Bar>echoh None<cr>
inorea ne_calloc	ne_calloc<c-o>:echoh HintHL<Bar>echo "void*ne_calloc(size_tsize)"<Bar>echoh None<cr>
inorea ne_get_error	ne_get_error<c-o>:echoh HintHL<Bar>echo "constchar*ne_get_error(ne_sesssion*session)"<Bar>echoh None<cr>
inorea ne_get_response_header	ne_get_response_header<c-o>:echoh HintHL<Bar>echo "constchar*ne_get_response_header(ne_request*request, constchar*name)"<Bar>echoh None<cr>
inorea ne_get_scheme	ne_get_scheme<c-o>:echoh HintHL<Bar>echo "constchar*ne_get_scheme(ne_sesssion*session)"<Bar>echoh None<cr>
inorea ne_get_server_hostport	ne_get_server_hostport<c-o>:echoh HintHL<Bar>echo "constchar*ne_get_server_hostport(ne_sesssion*session)"<Bar>echoh None<cr>
inorea ne_get_status	ne_get_status<c-o>:echoh HintHL<Bar>echo "constne_status*ne_get_status(constne_request*request)"<Bar>echoh None<cr>
inorea ne_iaddr_make	ne_iaddr_make<c-o>:echoh HintHL<Bar>echo "ne_inet_addr*ne_iaddr_make(ne_iaddr_typetype, constunsignedchar*raw)"<Bar>echoh None<cr>
inorea ne_iaddr_print	ne_iaddr_print<c-o>:echoh HintHL<Bar>echo "char*ne_iaddr_print(constne_inet_addr*ia, char*buffer, size_tbufsiz)"<Bar>echoh None<cr>
inorea ne_iaddr_typene_iaddr_typeof	ne_iaddr_typene_iaddr_typeof<c-o>:echoh HintHL<Bar>echo "ne_iaddr_typene_iaddr_typeof(constne_inet_addr*ia)"<Bar>echoh None<cr>
inorea ne_malloc	ne_malloc<c-o>:echoh HintHL<Bar>echo "void*ne_malloc(size_tsize)"<Bar>echoh None<cr>
inorea ne_qtoken	ne_qtoken<c-o>:echoh HintHL<Bar>echo "char*ne_qtoken(char**str, charsep, constchar*quotes)"<Bar>echoh None<cr>
inorea ne_realloc	ne_realloc<c-o>:echoh HintHL<Bar>echo "void*ne_realloc(void*size, size_tlen)"<Bar>echoh None<cr>
inorea ne_request_create	ne_request_create<c-o>:echoh HintHL<Bar>echo "ne_request*ne_request_create(ne_session*session, constchar*method, constchar*path)"<Bar>echoh None<cr>
inorea ne_response_header_iterate	ne_response_header_iterate<c-o>:echoh HintHL<Bar>echo "void*ne_response_header_iterate(ne_request*request, void*cursor, constchar**name, constchar**value)"<Bar>echoh None<cr>
inorea ne_session_create	ne_session_create<c-o>:echoh HintHL<Bar>echo "ne_session*ne_session_create(constchar*scheme, constchar*hostname, unsignedintport)"<Bar>echoh None<cr>
inorea ne_shave	ne_shave<c-o>:echoh HintHL<Bar>echo "char*ne_shave(char*str, constchar*whitespace)"<Bar>echoh None<cr>
inorea ne_ssl_cert_export	ne_ssl_cert_export<c-o>:echoh HintHL<Bar>echo "char*ne_ssl_cert_export(constne_ssl_certificate*cert)"<Bar>echoh None<cr>
inorea ne_ssl_cert_identity	ne_ssl_cert_identity<c-o>:echoh HintHL<Bar>echo "constchar*ne_ssl_cert_identity(constne_ssl_certificate*cert)"<Bar>echoh None<cr>
inorea ne_ssl_cert_import	ne_ssl_cert_import<c-o>:echoh HintHL<Bar>echo "ne_ssl_certificate*ne_ssl_cert_import(constchar*data)"<Bar>echoh None<cr>
inorea ne_ssl_cert_issuer	ne_ssl_cert_issuer<c-o>:echoh HintHL<Bar>echo "constne_ssl_dname*ne_ssl_cert_issuer(constne_ssl_certificate*cert)"<Bar>echoh None<cr>
inorea ne_ssl_cert_read	ne_ssl_cert_read<c-o>:echoh HintHL<Bar>echo "ne_ssl_certificate*ne_ssl_cert_read(constchar*filename)"<Bar>echoh None<cr>
inorea ne_ssl_cert_signedby	ne_ssl_cert_signedby<c-o>:echoh HintHL<Bar>echo "constne_ssl_certificate*ne_ssl_cert_signedby(constne_ssl_certificate*cert)"<Bar>echoh None<cr>
inorea ne_ssl_cert_subject	ne_ssl_cert_subject<c-o>:echoh HintHL<Bar>echo "constne_ssl_dname*ne_ssl_cert_subject(constne_ssl_certificate*cert)"<Bar>echoh None<cr>
inorea ne_ssl_clicert_name	ne_ssl_clicert_name<c-o>:echoh HintHL<Bar>echo "constchar*ne_ssl_clicert_name(constne_ssl_client_cert*ccert)"<Bar>echoh None<cr>
inorea ne_ssl_clicert_owner	ne_ssl_clicert_owner<c-o>:echoh HintHL<Bar>echo "constne_ssl_certificate*ne_ssl_clicert_owner(constne_ssl_client_cert*ccert)"<Bar>echoh None<cr>
inorea ne_ssl_clicert_read	ne_ssl_clicert_read<c-o>:echoh HintHL<Bar>echo "ne_ssl_client_cert*ne_ssl_clicert_read(constchar*filename)"<Bar>echoh None<cr>
inorea ne_ssl_readable_dname	ne_ssl_readable_dname<c-o>:echoh HintHL<Bar>echo "constchar*ne_ssl_readable_dname(constne_ssl_dname*dname)"<Bar>echoh None<cr>
inorea ne_strdup	ne_strdup<c-o>:echoh HintHL<Bar>echo "char*ne_strdup(constchar*s, size_tsize)"<Bar>echoh None<cr>
inorea ne_strndup	ne_strndup<c-o>:echoh HintHL<Bar>echo "char*ne_strndup(constchar*s, size_tsize)"<Bar>echoh None<cr>
inorea ne_token	ne_token<c-o>:echoh HintHL<Bar>echo "char*ne_token(char**str, charsep)"<Bar>echoh None<cr>
inorea ne_version_string	ne_version_string<c-o>:echoh HintHL<Bar>echo "constchar*ne_version_string(void)"<Bar>echoh None<cr>
inorea new_field	new_field<c-o>:echoh HintHL<Bar>echo "FIELD *new_field(int height, int width, int toprow, int leftcol, int offscreen, int nbuffers)"<Bar>echoh None<cr>
inorea new_form	new_form<c-o>:echoh HintHL<Bar>echo "FORM *new_form(FIELD **fields)"<Bar>echoh None<cr>
inorea new_item	new_item<c-o>:echoh HintHL<Bar>echo "ITEM *new_item(const char *name, const char *description)"<Bar>echoh None<cr>
inorea new_menu	new_menu<c-o>:echoh HintHL<Bar>echo "MENU *new_menu(ITEM **items)"<Bar>echoh None<cr>
inorea newpad	newpad<c-o>:echoh HintHL<Bar>echo "WINDOW *newpad(int nlines, int ncols)"<Bar>echoh None<cr>
inorea new_page	new_page<c-o>:echoh HintHL<Bar>echo "bool new_page(const FIELD *field)"<Bar>echoh None<cr>
inorea new_panel	new_panel<c-o>:echoh HintHL<Bar>echo "PANEL *new_panel(WINDOW *win)"<Bar>echoh None<cr>
inorea newterm	newterm<c-o>:echoh HintHL<Bar>echo "SCREEN *newterm(char *type, FILE *outfd, FILE *infd)"<Bar>echoh None<cr>
inorea newwin	newwin<c-o>:echoh HintHL<Bar>echo "WINDOW *newwin(int nlines, int ncols, int begin_y, int begin_x)"<Bar>echoh None<cr>
inorea ne_xml_create	ne_xml_create<c-o>:echoh HintHL<Bar>echo "ne_xml_parser*ne_xml_create(void)"<Bar>echoh None<cr>
inorea nextafterf	nextafterf<c-o>:echoh HintHL<Bar>echo "float nextafterf(float x, float y)"<Bar>echoh None<cr>
inorea nextafterl	nextafterl<c-o>:echoh HintHL<Bar>echo "long double nextafterl(long double x, long double y)"<Bar>echoh None<cr>
inorea nextafter	nextafter<c-o>:echoh HintHL<Bar>echo "double nextafter(double x, double y)"<Bar>echoh None<cr>
inorea nextkey	nextkey<c-o>:echoh HintHL<Bar>echo "nextkey (key)"<Bar>echoh None<cr>
inorea nexttowardf	nexttowardf<c-o>:echoh HintHL<Bar>echo "float nexttowardf(float x, long double y)"<Bar>echoh None<cr>
inorea nexttoward	nexttoward<c-o>:echoh HintHL<Bar>echo "double nexttoward(double x, long double y)"<Bar>echoh None<cr>
inorea nfs4_get_default_domain	nfs4_get_default_domain<c-o>:echoh HintHL<Bar>echo "int nfs4_get_default_domain(char *server, char *domain, size_t len)"<Bar>echoh None<cr>
inorea nfs4_get_grouplist	nfs4_get_grouplist<c-o>:echoh HintHL<Bar>echo "int nfs4_get_grouplist(const char *name, gid_t *groups, int *ngroups)"<Bar>echoh None<cr>
inorea nfs4_gid_to_name	nfs4_gid_to_name<c-o>:echoh HintHL<Bar>echo "int nfs4_gid_to_name(gid_t gid, char *domain, char *name, size_t len)"<Bar>echoh None<cr>
inorea nfs4_gss_princ_to_ids	nfs4_gss_princ_to_ids<c-o>:echoh HintHL<Bar>echo "int nfs4_gss_princ_to_ids(char *princ, uid_t *uid, gid_t *gid)"<Bar>echoh None<cr>
inorea nfs4_init_name_mapping	nfs4_init_name_mapping<c-o>:echoh HintHL<Bar>echo "int nfs4_init_name_mapping(char *conffile)"<Bar>echoh None<cr>
inorea nfs4_name_to_gid	nfs4_name_to_gid<c-o>:echoh HintHL<Bar>echo "int nfs4_name_to_gid(char *name, gid_t *gid)"<Bar>echoh None<cr>
inorea nfs4_name_to_uid	nfs4_name_to_uid<c-o>:echoh HintHL<Bar>echo "int nfs4_name_to_uid(char *name, uid_t *uid)"<Bar>echoh None<cr>
inorea nfs4_uid_to_name	nfs4_uid_to_name<c-o>:echoh HintHL<Bar>echo "int nfs4_uid_to_name(uid_t uid, char *domain, char *name, size_t len)"<Bar>echoh None<cr>
inorea nl_langinfo	nl_langinfo<c-o>:echoh HintHL<Bar>echo "char *nl_langinfo(nl_item item)"<Bar>echoh None<cr>
inorea NLMSG_ALIGN	NLMSG_ALIGN<c-o>:echoh HintHL<Bar>echo "int NLMSG_ALIGN(size_t len)"<Bar>echoh None<cr>
inorea NLMSG_DATA	NLMSG_DATA<c-o>:echoh HintHL<Bar>echo "void *NLMSG_DATA(struct nlmsghdr * nlh)"<Bar>echoh None<cr>
inorea NLMSG_LENGTH	NLMSG_LENGTH<c-o>:echoh HintHL<Bar>echo "int NLMSG_LENGTH(size_t len)"<Bar>echoh None<cr>
inorea NLMSG_NEXT	NLMSG_NEXT<c-o>:echoh HintHL<Bar>echo "struct nlmsghdr *NLMSG_NEXT(struct nlmsghdr * nlh, int len)"<Bar>echoh None<cr>
inorea NLMSG_OK	NLMSG_OK<c-o>:echoh HintHL<Bar>echo "int NLMSG_OK(struct nlmsghdr * nlh, int len)"<Bar>echoh None<cr>
inorea NLMSG_PAYLOAD	NLMSG_PAYLOAD<c-o>:echoh HintHL<Bar>echo "int NLMSG_PAYLOAD(struct nlmsghdr * nlh, int len)"<Bar>echoh None<cr>
inorea NLMSG_SPACE	NLMSG_SPACE<c-o>:echoh HintHL<Bar>echo "int NLMSG_SPACE(size_t len)"<Bar>echoh None<cr>
inorea nl	nl<c-o>:echoh HintHL<Bar>echo "int nl(void)"<Bar>echoh None<cr>
inorea nocbreak	nocbreak<c-o>:echoh HintHL<Bar>echo "int nocbreak(void)"<Bar>echoh None<cr>
inorea nodelay	nodelay<c-o>:echoh HintHL<Bar>echo "int nodelay(WINDOW *win, bool bf)"<Bar>echoh None<cr>
inorea noecho	noecho<c-o>:echoh HintHL<Bar>echo "int noecho(void)"<Bar>echoh None<cr>
inorea nonl	nonl<c-o>:echoh HintHL<Bar>echo "int nonl(void)"<Bar>echoh None<cr>
inorea noqiflush	noqiflush<c-o>:echoh HintHL<Bar>echo "void noqiflush(void)"<Bar>echoh None<cr>
inorea noraw	noraw<c-o>:echoh HintHL<Bar>echo "int noraw(void)"<Bar>echoh None<cr>
inorea notimeout	notimeout<c-o>:echoh HintHL<Bar>echo "int notimeout(WINDOW *win, bool bf)"<Bar>echoh None<cr>
inorea nrand48	nrand48<c-o>:echoh HintHL<Bar>echo "long int nrand48(unsigned short xsubi [3])"<Bar>echoh None<cr>
inorea nrand48_r	nrand48_r<c-o>:echoh HintHL<Bar>echo "int nrand48_r(unsigned short int xsubi[3], struct drand48_data *buffer, long int * result)"<Bar>echoh None<cr>
inorea ntohl	ntohl<c-o>:echoh HintHL<Bar>echo "uint32_t ntohl(uint32_t netlong)"<Bar>echoh None<cr>
inorea ntohs	ntohs<c-o>:echoh HintHL<Bar>echo "uint16_t ntohs(uint16_t netshort)"<Bar>echoh None<cr>
inorea numa_alloc_interleaved	numa_alloc_interleaved<c-o>:echoh HintHL<Bar>echo "void *numa_alloc_interleaved(size_t size)"<Bar>echoh None<cr>
inorea numa_alloc_interleaved_subset	numa_alloc_interleaved_subset<c-o>:echoh HintHL<Bar>echo "void *numa_alloc_interleaved_subset(size_t size, nodemask_t *nodemask)"<Bar>echoh None<cr>
inorea numa_alloc_local	numa_alloc_local<c-o>:echoh HintHL<Bar>echo "void *numa_alloc_local(size_t size)"<Bar>echoh None<cr>
inorea numa_alloc	numa_alloc<c-o>:echoh HintHL<Bar>echo "void *numa_alloc(size_t size)"<Bar>echoh None<cr>
inorea numa_alloc_onnode	numa_alloc_onnode<c-o>:echoh HintHL<Bar>echo "void *numa_alloc_onnode(size_t size, int node)"<Bar>echoh None<cr>
inorea numa_available	numa_available<c-o>:echoh HintHL<Bar>echo "int numa_available(void)"<Bar>echoh None<cr>
inorea numa_bind	numa_bind<c-o>:echoh HintHL<Bar>echo "void numa_bind(nodemask_t *nodemask)"<Bar>echoh None<cr>
inorea numa_error	numa_error<c-o>:echoh HintHL<Bar>echo "void numa_error(char *where)"<Bar>echoh None<cr>
inorea numa_free	numa_free<c-o>:echoh HintHL<Bar>echo "void numa_free(void *start, size_t size)"<Bar>echoh None<cr>
inorea numa_get_interleave_mask	numa_get_interleave_mask<c-o>:echoh HintHL<Bar>echo "nodemask_t numa_get_interleave_mask(void)"<Bar>echoh None<cr>
inorea numa_get_membind	numa_get_membind<c-o>:echoh HintHL<Bar>echo "nodemask_t numa_get_membind(void)"<Bar>echoh None<cr>
inorea numa_get_run_node_mask	numa_get_run_node_mask<c-o>:echoh HintHL<Bar>echo "int numa_get_run_node_mask(void)"<Bar>echoh None<cr>
inorea numa_interleave_memory	numa_interleave_memory<c-o>:echoh HintHL<Bar>echo "void numa_interleave_memory(void *start, size_t size, nodemask_t *nodemask)"<Bar>echoh None<cr>
inorea numa_max_node	numa_max_node<c-o>:echoh HintHL<Bar>echo "int numa_max_node(void)"<Bar>echoh None<cr>
inorea numa_node_size	numa_node_size<c-o>:echoh HintHL<Bar>echo "long numa_node_size(int node, long *freep)"<Bar>echoh None<cr>
inorea numa_node_to_cpus	numa_node_to_cpus<c-o>:echoh HintHL<Bar>echo "int numa_node_to_cpus(int node, unsigned long *buffer, int bufferlen)"<Bar>echoh None<cr>
inorea numa_police_memory	numa_police_memory<c-o>:echoh HintHL<Bar>echo "void numa_police_memory(void *start, size_t size)"<Bar>echoh None<cr>
inorea numa_preferred	numa_preferred<c-o>:echoh HintHL<Bar>echo "int numa_preferred(void)"<Bar>echoh None<cr>
inorea numa_run_on_node_mask	numa_run_on_node_mask<c-o>:echoh HintHL<Bar>echo "int numa_run_on_node_mask(nodemask_t *nodemask)"<Bar>echoh None<cr>
inorea numa_run_on_node	numa_run_on_node<c-o>:echoh HintHL<Bar>echo "int numa_run_on_node(int node)"<Bar>echoh None<cr>
inorea numa_set_interleave_mask	numa_set_interleave_mask<c-o>:echoh HintHL<Bar>echo "void numa_set_interleave_mask(nodemask_t *nodemask)"<Bar>echoh None<cr>
inorea numa_set_localalloc	numa_set_localalloc<c-o>:echoh HintHL<Bar>echo "void numa_set_localalloc(int flag)"<Bar>echoh None<cr>
inorea numa_setlocal_memory	numa_setlocal_memory<c-o>:echoh HintHL<Bar>echo "void numa_setlocal_memory(void *start, size_t size)"<Bar>echoh None<cr>
inorea numa_set_membind	numa_set_membind<c-o>:echoh HintHL<Bar>echo "void numa_set_membind(nodemask_t *nodemask)"<Bar>echoh None<cr>
inorea numa_set_preferred	numa_set_preferred<c-o>:echoh HintHL<Bar>echo "void numa_set_preferred(int node)"<Bar>echoh None<cr>
inorea numa_tonodemask_memory	numa_tonodemask_memory<c-o>:echoh HintHL<Bar>echo "void numa_tonodemask_memory(void *start, size_t size, nodemask_t *nodemask)"<Bar>echoh None<cr>
inorea numa_tonode_memory	numa_tonode_memory<c-o>:echoh HintHL<Bar>echo "void numa_tonode_memory(void *start, size_t size, int node)"<Bar>echoh None<cr>
inorea on_exit	on_exit<c-o>:echoh HintHL<Bar>echo "int on_exit(void (* function)(int, void *), void * arg)"<Bar>echoh None<cr>
inorea opendir	opendir<c-o>:echoh HintHL<Bar>echo "DIR *opendir(const char * name)"<Bar>echoh None<cr>
inorea openlog	openlog<c-o>:echoh HintHL<Bar>echo "void openlog(const char * ident, int option, int facility)"<Bar>echoh None<cr>
inorea open_memstream	open_memstream<c-o>:echoh HintHL<Bar>echo "FILE * open_memstream(char ** ptr, size_t * sizeloc)"<Bar>echoh None<cr>
inorea openpty	openpty<c-o>:echoh HintHL<Bar>echo "int openpty(int * amaster, int * aslave, char * name, struct termios * termp, struct winsize * winp)"<Bar>echoh None<cr>
inorea overlay	overlay<c-o>:echoh HintHL<Bar>echo "int overlay(const WINDOW *srcwin, WINDOW *dstwin)"<Bar>echoh None<cr>
inorea overwrite	overwrite<c-o>:echoh HintHL<Bar>echo "int overwrite(const WINDOW *srcwin, WINDOW *dstwin)"<Bar>echoh None<cr>
inorea pair_content	pair_content<c-o>:echoh HintHL<Bar>echo "int pair_content(short pair, short *f, short *b)"<Bar>echoh None<cr>
inorea pam_acct_mgmt	pam_acct_mgmt<c-o>:echoh HintHL<Bar>echo "int pam_acct_mgmt(pam_handle_t* pamh, intflags)"<Bar>echoh None<cr>
inorea pam_authenticate	pam_authenticate<c-o>:echoh HintHL<Bar>echo "int pam_authenticate(pam_handle_t* pamh, intflags)"<Bar>echoh None<cr>
inorea pam_chauthtok	pam_chauthtok<c-o>:echoh HintHL<Bar>echo "int pam_chauthtok(pam_handle_t* pamh, intflags)"<Bar>echoh None<cr>
inorea pam_close_session	pam_close_session<c-o>:echoh HintHL<Bar>echo "int pam_close_session(pam_handle_t* pamh, intflags)"<Bar>echoh None<cr>
inorea pam_end	pam_end<c-o>:echoh HintHL<Bar>echo "int pam_end(pam_handle_t* pamh, intpam_status)"<Bar>echoh None<cr>
inorea pam_error	pam_error<c-o>:echoh HintHL<Bar>echo "int pam_error(pam_handle_t* pamh, constchar* fmt, ...)"<Bar>echoh None<cr>
inorea pam_fail_delay	pam_fail_delay<c-o>:echoh HintHL<Bar>echo "int pam_fail_delay(pam_handle_t* pamh, unsignedintusec)"<Bar>echoh None<cr>
inorea pam_get_data	pam_get_data<c-o>:echoh HintHL<Bar>echo "int pam_get_data(constpam_handle_t* pamh, constchar* module_data_name, constvoid** data)"<Bar>echoh None<cr>
inorea pam_getenvlist	pam_getenvlist<c-o>:echoh HintHL<Bar>echo "char **pam_getenvlist(pam_handle_t* pamh)"<Bar>echoh None<cr>
inorea pam_getenv	pam_getenv<c-o>:echoh HintHL<Bar>echo "const char *pam_getenv(pam_handle_t* pamh, constchar* name)"<Bar>echoh None<cr>
inorea pam_get_item	pam_get_item<c-o>:echoh HintHL<Bar>echo "int pam_get_item(constpam_handle_t* pamh, intitem_type, constvoid** item)"<Bar>echoh None<cr>
inorea pam_get_user	pam_get_user<c-o>:echoh HintHL<Bar>echo "int pam_get_user(constpam_handle_t* pamh, constchar** user, constchar* prompt)"<Bar>echoh None<cr>
inorea pam_info	pam_info<c-o>:echoh HintHL<Bar>echo "int pam_info(pam_handle_t* pamh, constchar* fmt, ...)"<Bar>echoh None<cr>
inorea pam_misc_drop_env	pam_misc_drop_env<c-o>:echoh HintHL<Bar>echo "int pam_misc_drop_env(char** env)"<Bar>echoh None<cr>
inorea pam_misc_paste_env	pam_misc_paste_env<c-o>:echoh HintHL<Bar>echo "int pam_misc_paste_env(pam_handle_t* pamh, constchar*const* user)"<Bar>echoh None<cr>
inorea pam_misc_setenv	pam_misc_setenv<c-o>:echoh HintHL<Bar>echo "int pam_misc_setenv(pam_handle_t* pamh, constchar* name, constchar* value, int readonly)"<Bar>echoh None<cr>
inorea pam_open_session	pam_open_session<c-o>:echoh HintHL<Bar>echo "int pam_open_session(pam_handle_t* pamh, intflags)"<Bar>echoh None<cr>
inorea pam_prompt	pam_prompt<c-o>:echoh HintHL<Bar>echo "void pam_prompt(pam_handle_t* pamh, intstyle, char** response, constchar* fmt, ...)"<Bar>echoh None<cr>
inorea pam_putenv	pam_putenv<c-o>:echoh HintHL<Bar>echo "int pam_putenv(pam_handle_t* pamh, constchar* name_value)"<Bar>echoh None<cr>
inorea pam_setcred	pam_setcred<c-o>:echoh HintHL<Bar>echo "int pam_setcred(pam_handle_t* pamh, intflags)"<Bar>echoh None<cr>
inorea pam_set_data	pam_set_data<c-o>:echoh HintHL<Bar>echo "int pam_set_data(pam_handle_t* pamh, constchar* module_data_name, void* data, void(*cleanup)(pam_handle_t*pamh,void*data,interror_status))"<Bar>echoh None<cr>
inorea pam_set_item	pam_set_item<c-o>:echoh HintHL<Bar>echo "int pam_set_item(pam_handle_t* pamh, intitem_type, constvoid* item)"<Bar>echoh None<cr>
inorea pam_sm_acct_mgmt	pam_sm_acct_mgmt<c-o>:echoh HintHL<Bar>echo "PAM_EXTERN int pam_sm_acct_mgmt(pam_handle_t* pamh, intflags, intargc, constchar** argv)"<Bar>echoh None<cr>
inorea pam_sm_authenticate	pam_sm_authenticate<c-o>:echoh HintHL<Bar>echo "PAM_EXTERN int pam_sm_authenticate(pam_handle_t* pamh, intflags, intargc, constchar** argv)"<Bar>echoh None<cr>
inorea pam_sm_chauthtok	pam_sm_chauthtok<c-o>:echoh HintHL<Bar>echo "PAM_EXTERN int pam_sm_chauthtok(pam_handle_t* pamh, intflags, intargc, constchar** argv)"<Bar>echoh None<cr>
inorea pam_sm_close_session	pam_sm_close_session<c-o>:echoh HintHL<Bar>echo "PAM_EXTERN int pam_sm_close_session(pam_handle_t* pamh, intflags, intargc, constchar** argv)"<Bar>echoh None<cr>
inorea pam_sm_open_session	pam_sm_open_session<c-o>:echoh HintHL<Bar>echo "PAM_EXTERN int pam_sm_open_session(pam_handle_t* pamh, intflags, intargc, constchar** argv)"<Bar>echoh None<cr>
inorea pam_sm_setcred	pam_sm_setcred<c-o>:echoh HintHL<Bar>echo "PAM_EXTERN int pam_sm_setcred(pam_handle_t* pamh, intflags, intargc, constchar** argv)"<Bar>echoh None<cr>
inorea pam_start	pam_start<c-o>:echoh HintHL<Bar>echo "int pam_start(constchar* service_name, constchar* user, conststructpam_conv* pam_conversation, pam_handle_t** pamh)"<Bar>echoh None<cr>
inorea pam_strerror	pam_strerror<c-o>:echoh HintHL<Bar>echo "const char *pam_strerror(pam_handle_t* pamh, interrnum)"<Bar>echoh None<cr>
inorea pam_syslog	pam_syslog<c-o>:echoh HintHL<Bar>echo "void pam_syslog(pam_handle_t* pamh, intpriority, constchar* fmt, ...)"<Bar>echoh None<cr>
inorea pam_verror	pam_verror<c-o>:echoh HintHL<Bar>echo "int pam_verror(pam_handle_t* pamh, constchar* fmt, va_listargs)"<Bar>echoh None<cr>
inorea pam_vinfo	pam_vinfo<c-o>:echoh HintHL<Bar>echo "int pam_vinfo(pam_handle_t* pamh, constchar* fmt, va_listargs)"<Bar>echoh None<cr>
inorea pam_vprompt	pam_vprompt<c-o>:echoh HintHL<Bar>echo "void pam_vprompt(pam_handle_t* pamh, intstyle, char** response, constchar* fmt, va_listargs)"<Bar>echoh None<cr>
inorea pam_vsyslog	pam_vsyslog<c-o>:echoh HintHL<Bar>echo "void pam_vsyslog(pam_handle_t* pamh, intpriority, constchar* fmt, va_listargs)"<Bar>echoh None<cr>
inorea panel_above	panel_above<c-o>:echoh HintHL<Bar>echo "PANEL *panel_above(const PANEL *pan)"<Bar>echoh None<cr>
inorea panel_below	panel_below<c-o>:echoh HintHL<Bar>echo "PANEL *panel_below(const PANEL *pan)"<Bar>echoh None<cr>
inorea panel_hidden	panel_hidden<c-o>:echoh HintHL<Bar>echo "int panel_hidden(const PANEL *pan)"<Bar>echoh None<cr>
inorea panel_userptr	panel_userptr<c-o>:echoh HintHL<Bar>echo "const void *panel_userptr(const PANEL *pan)"<Bar>echoh None<cr>
inorea panel_window	panel_window<c-o>:echoh HintHL<Bar>echo "WINDOW *panel_window(const PANEL *pan)"<Bar>echoh None<cr>
inorea passwd2des	passwd2des<c-o>:echoh HintHL<Bar>echo "void passwd2des (char *passwd, char * key)"<Bar>echoh None<cr>
inorea pathconf	pathconf<c-o>:echoh HintHL<Bar>echo "long pathconf(char * path, int name)"<Bar>echoh None<cr>
inorea pattern	pattern<c-o>:echoh HintHL<Bar>echo "# Create a string representing an optimized pattern (a la Friedl)"<Bar>echoh None<cr>
inorea pcap_breakloop	pcap_breakloop<c-o>:echoh HintHL<Bar>echo "void pcap_breakloop(pcap_t *)"<Bar>echoh None<cr>
inorea pcap_close	pcap_close<c-o>:echoh HintHL<Bar>echo "void pcap_close(pcap_t *p)"<Bar>echoh None<cr>
inorea pcap_datalink_name_to_val	pcap_datalink_name_to_val<c-o>:echoh HintHL<Bar>echo "int pcap_datalink_name_to_val(const char *name)"<Bar>echoh None<cr>
inorea pcap_datalink	pcap_datalink<c-o>:echoh HintHL<Bar>echo "int pcap_datalink(pcap_t *p)"<Bar>echoh None<cr>
inorea pcap_datalink_val_to_description	pcap_datalink_val_to_description<c-o>:echoh HintHL<Bar>echo "const char *pcap_datalink_val_to_description(int dlt)"<Bar>echoh None<cr>
inorea pcap_datalink_val_to_name	pcap_datalink_val_to_name<c-o>:echoh HintHL<Bar>echo "const char *pcap_datalink_val_to_name(int dlt)"<Bar>echoh None<cr>
inorea pcap_dump_close	pcap_dump_close<c-o>:echoh HintHL<Bar>echo "void pcap_dump_close(pcap_dumper_t *p)"<Bar>echoh None<cr>
inorea pcap_dump_file	pcap_dump_file<c-o>:echoh HintHL<Bar>echo "FILE *pcap_dump_file(pcap_dumper_t *p)"<Bar>echoh None<cr>
inorea pcap_dump_flush	pcap_dump_flush<c-o>:echoh HintHL<Bar>echo "int pcap_dump_flush(pcap_dumper_t *p)"<Bar>echoh None<cr>
inorea pcap_dump_fopen	pcap_dump_fopen<c-o>:echoh HintHL<Bar>echo "pcap_dumper_t *pcap_dump_fopen(pcap_t *p, FILE *fp)"<Bar>echoh None<cr>
inorea pcap_dump_ftell	pcap_dump_ftell<c-o>:echoh HintHL<Bar>echo "long pcap_dump_ftell(pcap_dumper_t *p)"<Bar>echoh None<cr>
inorea pcap_dump_open	pcap_dump_open<c-o>:echoh HintHL<Bar>echo "pcap_dumper_t *pcap_dump_open(pcap_t *p, const char *fname)"<Bar>echoh None<cr>
inorea pcap_fileno	pcap_fileno<c-o>:echoh HintHL<Bar>echo "int pcap_fileno(pcap_t *p)"<Bar>echoh None<cr>
inorea pcap_file	pcap_file<c-o>:echoh HintHL<Bar>echo "FILE *pcap_file(pcap_t *p)"<Bar>echoh None<cr>
inorea pcap_findalldevs	pcap_findalldevs<c-o>:echoh HintHL<Bar>echo "int pcap_findalldevs(pcap_if_t **alldevsp, char *errbuf)"<Bar>echoh None<cr>
inorea pcap_fopen_offline	pcap_fopen_offline<c-o>:echoh HintHL<Bar>echo "pcap_t *pcap_fopen_offline(FILE *fp, char *errbuf)"<Bar>echoh None<cr>
inorea pcap_freealldevs	pcap_freealldevs<c-o>:echoh HintHL<Bar>echo "void pcap_freealldevs(pcap_if_t *alldevs)"<Bar>echoh None<cr>
inorea pcap_freecode	pcap_freecode<c-o>:echoh HintHL<Bar>echo "void pcap_freecode(struct bpf_program *)"<Bar>echoh None<cr>
inorea pcap_geterr	pcap_geterr<c-o>:echoh HintHL<Bar>echo "char *pcap_geterr(pcap_t *p)"<Bar>echoh None<cr>
inorea pcap_getnonblock	pcap_getnonblock<c-o>:echoh HintHL<Bar>echo "int pcap_getnonblock(pcap_t *p, char *errbuf)"<Bar>echoh None<cr>
inorea pcap_get_selectable_fd	pcap_get_selectable_fd<c-o>:echoh HintHL<Bar>echo "int pcap_get_selectable_fd(pcap_t *p)"<Bar>echoh None<cr>
inorea pcap_inject	pcap_inject<c-o>:echoh HintHL<Bar>echo "int pcap_inject(pcap_t *p, const void *buf, size_t size)"<Bar>echoh None<cr>
inorea pcap_is_swapped	pcap_is_swapped<c-o>:echoh HintHL<Bar>echo "int pcap_is_swapped(pcap_t *p)"<Bar>echoh None<cr>
inorea pcap_lib_version	pcap_lib_version<c-o>:echoh HintHL<Bar>echo "const char *pcap_lib_version(void)"<Bar>echoh None<cr>
inorea pcap_list_datalinks	pcap_list_datalinks<c-o>:echoh HintHL<Bar>echo "int pcap_list_datalinks(pcap_t *p, int **dlt_buf)"<Bar>echoh None<cr>
inorea pcap_lookupdev	pcap_lookupdev<c-o>:echoh HintHL<Bar>echo "char *pcap_lookupdev(char *errbuf)"<Bar>echoh None<cr>
inorea pcap_major_version	pcap_major_version<c-o>:echoh HintHL<Bar>echo "int pcap_major_version(pcap_t *p)"<Bar>echoh None<cr>
inorea pcap_minor_version	pcap_minor_version<c-o>:echoh HintHL<Bar>echo "int pcap_minor_version(pcap_t *p)"<Bar>echoh None<cr>
inorea pcap_next	pcap_next<c-o>:echoh HintHL<Bar>echo "const u_char *pcap_next(pcap_t *p, struct pcap_pkthdr *h)"<Bar>echoh None<cr>
inorea pcap_open_dead	pcap_open_dead<c-o>:echoh HintHL<Bar>echo "pcap_t *pcap_open_dead(int linktype, int snaplen)"<Bar>echoh None<cr>
inorea pcap_open_offline	pcap_open_offline<c-o>:echoh HintHL<Bar>echo "pcap_t *pcap_open_offline(const char *fname, char *errbuf)"<Bar>echoh None<cr>
inorea pcap_perror	pcap_perror<c-o>:echoh HintHL<Bar>echo "void pcap_perror(pcap_t *p, char *prefix)"<Bar>echoh None<cr>
inorea pcap_sendpacket	pcap_sendpacket<c-o>:echoh HintHL<Bar>echo "int pcap_sendpacket(pcap_t *p, const u_char *buf, int size)"<Bar>echoh None<cr>
inorea pcap_set_datalink	pcap_set_datalink<c-o>:echoh HintHL<Bar>echo "int pcap_set_datalink(pcap_t *p, int dlt)"<Bar>echoh None<cr>
inorea pcap_setdirection	pcap_setdirection<c-o>:echoh HintHL<Bar>echo "int pcap_setdirection(pcap_t *p, pcap_direction_t d)"<Bar>echoh None<cr>
inorea pcap_setfilter	pcap_setfilter<c-o>:echoh HintHL<Bar>echo "int pcap_setfilter(pcap_t *p, struct bpf_program *fp)"<Bar>echoh None<cr>
inorea pcap_setnonblock	pcap_setnonblock<c-o>:echoh HintHL<Bar>echo "int pcap_setnonblock(pcap_t *p, int nonblock, char *errbuf)"<Bar>echoh None<cr>
inorea pcap_snapshot	pcap_snapshot<c-o>:echoh HintHL<Bar>echo "int pcap_snapshot(pcap_t *p)"<Bar>echoh None<cr>
inorea pcap_stats	pcap_stats<c-o>:echoh HintHL<Bar>echo "int pcap_stats(pcap_t *p, struct pcap_stat *ps)"<Bar>echoh None<cr>
inorea pcap_strerror	pcap_strerror<c-o>:echoh HintHL<Bar>echo "char *pcap_strerror(int error)"<Bar>echoh None<cr>
inorea pclose	pclose<c-o>:echoh HintHL<Bar>echo "int pclose(FILE * stream)"<Bar>echoh None<cr>
inorea pechochar	pechochar<c-o>:echoh HintHL<Bar>echo "int pechochar(WINDOW *pad, chtype ch)"<Bar>echoh None<cr>
inorea pecho_wchar	pecho_wchar<c-o>:echoh HintHL<Bar>echo "int pecho_wchar(WINDOW *pad, const cchar_t *wch)"<Bar>echoh None<cr>
inorea perror	perror<c-o>:echoh HintHL<Bar>echo "void perror(const char *s)"<Bar>echoh None<cr>
inorea PKCS12_parse	PKCS12_parse<c-o>:echoh HintHL<Bar>echo "int PKCS12_parse(\s-1PKCS12\s0 *p12, const char *pass, \s-1EVP_PKEY\s0 **pkey, X509 **cert, \s-1STACK_OF\s0(X509) **ca)"<Bar>echoh None<cr>
inorea PKCS7_decrypt	PKCS7_decrypt<c-o>:echoh HintHL<Bar>echo "int PKCS7_decrypt(\s-1PKCS7\s0 *p7, \s-1EVP_PKEY\s0 *pkey, X509 *cert, \s-1BIO\s0 *data, int flags)"<Bar>echoh None<cr>
inorea PKCS7_get0_signers	PKCS7_get0_signers<c-o>:echoh HintHL<Bar>echo "int PKCS7_get0_signers(\s-1PKCS7\s0 *p7, \s-1STACK_OF\s0(X509) *certs, int flags)"<Bar>echoh None<cr>
inorea PKCS7_verify	PKCS7_verify<c-o>:echoh HintHL<Bar>echo "int PKCS7_verify(\s-1PKCS7\s0 *p7, \s-1STACK_OF\s0(X509) *certs, X509_STORE *store, \s-1BIO\s0 *indata, \s-1BIO\s0 *out, int flags)"<Bar>echoh None<cr>
inorea pm_tmpfile	pm_tmpfile<c-o>:echoh HintHL<Bar>echo "pm_tmpfile(void)"<Bar>echoh None<cr>
inorea png_get_rgb_to_gray_status	png_get_rgb_to_gray_status<c-o>:echoh HintHL<Bar>echo "png_byte png_get_rgb_to_gray_status (png_structp png_ptr)"<Bar>echoh None<cr>
inorea pnoutrefresh	pnoutrefresh<c-o>:echoh HintHL<Bar>echo "int pnoutrefresh(WINDOW *pad, int pminrow, int pmincol, int sminrow, int smincol, int smaxrow, int smaxcol)"<Bar>echoh None<cr>
inorea podchecker	podchecker<c-o>:echoh HintHL<Bar>echo "Subsection podchecker()"<Bar>echoh None<cr>
inorea policy	policy<c-o>:echoh HintHL<Bar>echo "PvmPollType 19 Message wait policy (shared memory)"<Bar>echoh None<cr>
inorea popen	popen<c-o>:echoh HintHL<Bar>echo "FILE *popen(const char * command, const char * type)"<Bar>echoh None<cr>
inorea poptAddAlias	poptAddAlias<c-o>:echoh HintHL<Bar>echo "int poptAddAlias(poptContext con, struct poptAlias alias, int flags)"<Bar>echoh None<cr>
inorea poptBadOption	poptBadOption<c-o>:echoh HintHL<Bar>echo "const char * poptBadOption(poptContext con, int flags)"<Bar>echoh None<cr>
inorea poptDupArgv	poptDupArgv<c-o>:echoh HintHL<Bar>echo "int poptDupArgv(int argc, const char ** argv, int * argcPtr, const char *** argvPtr)"<Bar>echoh None<cr>
inorea poptFreeContext	poptFreeContext<c-o>:echoh HintHL<Bar>echo "void poptFreeContext(poptContext con)"<Bar>echoh None<cr>
inorea poptGetArg	poptGetArg<c-o>:echoh HintHL<Bar>echo "const char * poptGetArg(poptContext con)"<Bar>echoh None<cr>
inorea poptGetArgs	poptGetArgs<c-o>:echoh HintHL<Bar>echo "const char ** poptGetArgs(poptContext con)"<Bar>echoh None<cr>
inorea poptGetContext	poptGetContext<c-o>:echoh HintHL<Bar>echo "poptContext poptGetContext(const char * name, int argc, const char ** argv, const struct poptOption * options, int flags)"<Bar>echoh None<cr>
inorea poptGetNextOpt	poptGetNextOpt<c-o>:echoh HintHL<Bar>echo "int poptGetNextOpt(poptContext con)"<Bar>echoh None<cr>
inorea poptGetOptArg	poptGetOptArg<c-o>:echoh HintHL<Bar>echo "const char * poptGetOptArg(poptContext con)"<Bar>echoh None<cr>
inorea poptParseArgvString	poptParseArgvString<c-o>:echoh HintHL<Bar>echo "int poptParseArgvString(char * s, int * argcPtr, const char *** argvPtr)"<Bar>echoh None<cr>
inorea poptPeekArg	poptPeekArg<c-o>:echoh HintHL<Bar>echo "const char * poptPeekArg(poptContext con)"<Bar>echoh None<cr>
inorea poptReadConfigFile	poptReadConfigFile<c-o>:echoh HintHL<Bar>echo "int poptReadConfigFile(poptContext con, char * fn)"<Bar>echoh None<cr>
inorea poptReadDefaultConfig	poptReadDefaultConfig<c-o>:echoh HintHL<Bar>echo "int poptReadDefaultConfig(poptContext con, int flags)"<Bar>echoh None<cr>
inorea poptResetContext	poptResetContext<c-o>:echoh HintHL<Bar>echo "void poptResetContext(poptContext con)"<Bar>echoh None<cr>
inorea poptStrerror	poptStrerror<c-o>:echoh HintHL<Bar>echo "const char *const poptStrerror(const int error)"<Bar>echoh None<cr>
inorea poptStuffArgs	poptStuffArgs<c-o>:echoh HintHL<Bar>echo "int poptStuffArgs(poptContext con, const char ** argv)"<Bar>echoh None<cr>
inorea pos_form_cursor	pos_form_cursor<c-o>:echoh HintHL<Bar>echo "int pos_form_cursor(FORM *form)"<Bar>echoh None<cr>
inorea posix_memalign	posix_memalign<c-o>:echoh HintHL<Bar>echo "int posix_memalign(void ** memptr, size_t alignment, size_t size)"<Bar>echoh None<cr>
inorea posix_openpt	posix_openpt<c-o>:echoh HintHL<Bar>echo "char *posix_openpt(int flags)"<Bar>echoh None<cr>
inorea pos_menu_cursor	pos_menu_cursor<c-o>:echoh HintHL<Bar>echo "int pos_menu_cursor(const MENU *menu)"<Bar>echoh None<cr>
inorea post_form	post_form<c-o>:echoh HintHL<Bar>echo "int post_form(FORM *form)"<Bar>echoh None<cr>
inorea post_menu	post_menu<c-o>:echoh HintHL<Bar>echo "int post_menu(MENU *menu)"<Bar>echoh None<cr>
inorea pow10f	pow10f<c-o>:echoh HintHL<Bar>echo "float pow10f(float x)"<Bar>echoh None<cr>
inorea pow10l	pow10l<c-o>:echoh HintHL<Bar>echo "long double pow10l(long double x)"<Bar>echoh None<cr>
inorea pow10	pow10<c-o>:echoh HintHL<Bar>echo "double pow10(double x)"<Bar>echoh None<cr>
inorea powf	powf<c-o>:echoh HintHL<Bar>echo "float powf(float x, float y)"<Bar>echoh None<cr>
inorea powl	powl<c-o>:echoh HintHL<Bar>echo "long double powl(long double x, long double y)"<Bar>echoh None<cr>
inorea pow	pow<c-o>:echoh HintHL<Bar>echo "double pow(double x, double y)"<Bar>echoh None<cr>
inorea pr29_4	pr29_4<c-o>:echoh HintHL<Bar>echo "int pr29_4(const uint32_t * in, size_t len)"<Bar>echoh None<cr>
inorea pr29_4z	pr29_4z<c-o>:echoh HintHL<Bar>echo "int pr29_4z(const uint32_t * in)"<Bar>echoh None<cr>
inorea pr29_8z	pr29_8z<c-o>:echoh HintHL<Bar>echo "int pr29_8z(const char * in)"<Bar>echoh None<cr>
inorea pr29_strerror	pr29_strerror<c-o>:echoh HintHL<Bar>echo "const char * pr29_strerror(Pr29_rc rc)"<Bar>echoh None<cr>
inorea prefresh	prefresh<c-o>:echoh HintHL<Bar>echo "int prefresh(WINDOW *pad, int pminrow, int pmincol, int sminrow, int smincol, int smaxrow, int smaxcol)"<Bar>echoh None<cr>
inorea printf	printf<c-o>:echoh HintHL<Bar>echo "int printf(const char * format, ...)"<Bar>echoh None<cr>
inorea printw	printw<c-o>:echoh HintHL<Bar>echo "int printw(const char *fmt, ...)"<Bar>echoh None<cr>
inorea profiling	profiling<c-o>:echoh HintHL<Bar>echo "PvmTraceCount 3 Only do PVM routine profiling (call counts)"<Bar>echoh None<cr>
inorea profil	profil<c-o>:echoh HintHL<Bar>echo "int profil(u_short * buf, size_t bufsiz, size_t offset, u_int scale)"<Bar>echoh None<cr>
inorea prop_clear	prop_clear<c-o>:echoh HintHL<Bar>echo "void prop_clear(struct propctx *ctx, int requests)"<Bar>echoh None<cr>
inorea prop_dispose	prop_dispose<c-o>:echoh HintHL<Bar>echo "void prop_dispose(struct propctx **ctx)"<Bar>echoh None<cr>
inorea prop_dup	prop_dup<c-o>:echoh HintHL<Bar>echo "int prop_dup(struct propctx *src_ctx, struct propctx *dst_ctx)"<Bar>echoh None<cr>
inorea prop_erase	prop_erase<c-o>:echoh HintHL<Bar>echo "void prop_erase(struct propctx *ctx, const char *name)"<Bar>echoh None<cr>
inorea prop_format	prop_format<c-o>:echoh HintHL<Bar>echo "int prop_format(struct propctx *ctx, const char *sep, int seplen, char *outbuf, unsigned outmax, unsigned *outlen)"<Bar>echoh None<cr>
inorea prop_getnames	prop_getnames<c-o>:echoh HintHL<Bar>echo "int prop_getnames(struct propctx *ctx, const char **names, struct porpval *vals)"<Bar>echoh None<cr>
inorea prop_get	prop_get<c-o>:echoh HintHL<Bar>echo "const struct propval *prop_get(struct propctx *ctx)"<Bar>echoh None<cr>
inorea prop_request	prop_request<c-o>:echoh HintHL<Bar>echo "int prop_request(struct propctx *ctx, const char **names)"<Bar>echoh None<cr>
inorea prop_set	prop_set<c-o>:echoh HintHL<Bar>echo "int prop_set(struct propctx *ctx, const char *name, const char *value, int vallen)"<Bar>echoh None<cr>
inorea prop_setvals	prop_setvals<c-o>:echoh HintHL<Bar>echo "int prop_setvals(struct propctx *ctx, const char *name, const char **values)"<Bar>echoh None<cr>
inorea psignal	psignal<c-o>:echoh HintHL<Bar>echo "void psignal(int sig, const char * s)"<Bar>echoh None<cr>
inorea ptsname	ptsname<c-o>:echoh HintHL<Bar>echo "char *ptsname(int fd)"<Bar>echoh None<cr>
inorea ptsname_r	ptsname_r<c-o>:echoh HintHL<Bar>echo "char *ptsname_r(int fd, char * buf, size_t buflen)"<Bar>echoh None<cr>
inorea punycode_decode	punycode_decode<c-o>:echoh HintHL<Bar>echo "int punycode_decode(size_t input_length, const char [] input, size_t * output_length, punycode_uint [] output, unsigned char [] case_flags)"<Bar>echoh None<cr>
inorea punycode_encode	punycode_encode<c-o>:echoh HintHL<Bar>echo "int punycode_encode(size_t input_length, const punycode_uint [] input, const unsigned char [] case_flags, size_t * output_length, char [] output)"<Bar>echoh None<cr>
inorea punycode_strerror	punycode_strerror<c-o>:echoh HintHL<Bar>echo "const char * punycode_strerror(Punycode_status rc)"<Bar>echoh None<cr>
inorea putchar	putchar<c-o>:echoh HintHL<Bar>echo "int putchar(int c)"<Bar>echoh None<cr>
inorea putchar_unlocked	putchar_unlocked<c-o>:echoh HintHL<Bar>echo "int putchar_unlocked(int c)"<Bar>echoh None<cr>
inorea putc	putc<c-o>:echoh HintHL<Bar>echo "int putc(int c, FILE * stream)"<Bar>echoh None<cr>
inorea putc_unlocked	putc_unlocked<c-o>:echoh HintHL<Bar>echo "int putc_unlocked(int c, FILE * stream)"<Bar>echoh None<cr>
inorea putenv	putenv<c-o>:echoh HintHL<Bar>echo "int putenv(char * string)"<Bar>echoh None<cr>
inorea putgrent	putgrent<c-o>:echoh HintHL<Bar>echo "int putgrent(const struct group * grp, FILE * fp)"<Bar>echoh None<cr>
inorea putp	putp<c-o>:echoh HintHL<Bar>echo "int putp(const char *str)"<Bar>echoh None<cr>
inorea putpwent	putpwent<c-o>:echoh HintHL<Bar>echo "int putpwent(const struct passwd * p, FILE * stream)"<Bar>echoh None<cr>
inorea puts	puts<c-o>:echoh HintHL<Bar>echo "int puts(const char * s)"<Bar>echoh None<cr>
inorea pututline	pututline<c-o>:echoh HintHL<Bar>echo "struct utmp *pututline(struct utmp * ut)"<Bar>echoh None<cr>
inorea putwchar	putwchar<c-o>:echoh HintHL<Bar>echo "wint_t putwchar(wchar_t wc)"<Bar>echoh None<cr>
inorea putwchar_unlocked	putwchar_unlocked<c-o>:echoh HintHL<Bar>echo "wint_t putwchar_unlocked(wchar_t wc)"<Bar>echoh None<cr>
inorea putwc	putwc<c-o>:echoh HintHL<Bar>echo "wint_t putwc(wchar_t wc, FILE * stream)"<Bar>echoh None<cr>
inorea putwc_unlocked	putwc_unlocked<c-o>:echoh HintHL<Bar>echo "wint_t putwc_unlocked(wchar_t wc, FILE * stream)"<Bar>echoh None<cr>
inorea putwin	putwin<c-o>:echoh HintHL<Bar>echo "int putwin(WINDOW *win, FILE *filep)"<Bar>echoh None<cr>
inorea putw	putw<c-o>:echoh HintHL<Bar>echo "int putw(int w, FILE * stream)"<Bar>echoh None<cr>
inorea pvmfaddhost	pvmfaddhost<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfaddhost( host, info)"<Bar>echoh None<cr>
inorea pvmfadvise	pvmfadvise<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfadvise( route, info)"<Bar>echoh None<cr>
inorea pvmfarchcode	pvmfarchcode<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfarchcode( arch, cod)"<Bar>echoh None<cr>
inorea pvmfbarrier	pvmfbarrier<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfbarrier( group, count, info)"<Bar>echoh None<cr>
inorea pvmfbcast	pvmfbcast<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfbcast( group, msgtag, info)"<Bar>echoh None<cr>
inorea pvmfbufinfo	pvmfbufinfo<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfbufinfo( bufid, bytes, msgtag, tid, info)"<Bar>echoh None<cr>
inorea pvmfcatchout	pvmfcatchout<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfcatchout( onoff, info)"<Bar>echoh None<cr>
inorea pvmfconfig	pvmfconfig<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfconfig( nhost, narch, dtid, name, arch, speed, info)"<Bar>echoh None<cr>
inorea pvmfdelhost	pvmfdelhost<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfdelhost( host, info)"<Bar>echoh None<cr>
inorea pvmfdelinfo	pvmfdelinfo<c-o>:echoh HintHL<Bar>echo " call pvmfdelinfo( name, index, flags, info)"<Bar>echoh None<cr>
inorea pvmfexit	pvmfexit<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfexit( info)"<Bar>echoh None<cr>
inorea pvmffreebuf	pvmffreebuf<c-o>:echoh HintHL<Bar>echo "Fortran call pvmffreebuf( bufid, info)"<Bar>echoh None<cr>
inorea pvmffreecontext	pvmffreecontext<c-o>:echoh HintHL<Bar>echo " call pvmffreecontext( ctx, info)"<Bar>echoh None<cr>
inorea pvmffreezegroup	pvmffreezegroup<c-o>:echoh HintHL<Bar>echo "Fortran call pvmffreezegroup( group, size, info)"<Bar>echoh None<cr>
inorea pvmfgather	pvmfgather<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfgather(result, data, count, datatype, msgtag, group, rootginst, info)"<Bar>echoh None<cr>
inorea pvmfgetcontext	pvmfgetcontext<c-o>:echoh HintHL<Bar>echo " call pvmfgetcontext( ctx)"<Bar>echoh None<cr>
inorea pvmfgetinst	pvmfgetinst<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfgetinst( group, tid, inum)"<Bar>echoh None<cr>
inorea pvmfgetmboxinfo	pvmfgetmboxinfo<c-o>:echoh HintHL<Bar>echo " call pvmfgetmboxinfo( pattern, name, nclasses, nentries, index, owner, flags, info)"<Bar>echoh None<cr>
inorea pvmfgetopt	pvmfgetopt<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfgetopt( what, val)"<Bar>echoh None<cr>
inorea pvmfgetrbuf	pvmfgetrbuf<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfgetrbuf( bufid)"<Bar>echoh None<cr>
inorea pvmfgetsbuf	pvmfgetsbuf<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfgetsbuf( bufid)"<Bar>echoh None<cr>
inorea pvmfgettid	pvmfgettid<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfgettid( group, inum, tid)"<Bar>echoh None<cr>
inorea pvmfgsize	pvmfgsize<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfgsize( group, size)"<Bar>echoh None<cr>
inorea pvmfhalt	pvmfhalt<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfhalt( info)"<Bar>echoh None<cr>
inorea pvmfhostsync	pvmfhostsync<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfhostsync( host, clksec, clkusec, deltasec, deltausec, info)"<Bar>echoh None<cr>
inorea pvmfinitsend	pvmfinitsend<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfinitsend( encoding, bufid)"<Bar>echoh None<cr>
inorea pvmfjoingroup	pvmfjoingroup<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfjoingroup( group, inum)"<Bar>echoh None<cr>
inorea pvmfkill	pvmfkill<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfkill( tid, info)"<Bar>echoh None<cr>
inorea pvmflvgroup	pvmflvgroup<c-o>:echoh HintHL<Bar>echo "Fortran call pvmflvgroup( group, info)"<Bar>echoh None<cr>
inorea pvmfmcast	pvmfmcast<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfmcast( ntask, tids, msgtag, info)"<Bar>echoh None<cr>
inorea pvmfmkbuf	pvmfmkbuf<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfmkbuf( encoding, bufid)"<Bar>echoh None<cr>
inorea pvmfmstat	pvmfmstat<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfmstat( host, mstat)"<Bar>echoh None<cr>
inorea pvmfmytid	pvmfmytid<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfmytid( tid)"<Bar>echoh None<cr>
inorea pvmfnewcontext	pvmfnewcontext<c-o>:echoh HintHL<Bar>echo " call pvmfnewcontext( ctx)"<Bar>echoh None<cr>
inorea pvmfnotify	pvmfnotify<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfnotify( what, msgtag, cnt, tids, info)"<Bar>echoh None<cr>
inorea pvmfnrecv	pvmfnrecv<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfnrecv( tid, msgtag, bufid)"<Bar>echoh None<cr>
inorea pvmfpack	pvmfpack<c-o>:echoh HintHL<Bar>echo " call pvmfpack( what, xp, nitem, stride, info)"<Bar>echoh None<cr>
inorea pvmfparent	pvmfparent<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfparent( tid)"<Bar>echoh None<cr>
inorea pvmfperror	pvmfperror<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfperror( msg, info)"<Bar>echoh None<cr>
inorea pvmfpkmesgbody	pvmfpkmesgbody<c-o>:echoh HintHL<Bar>echo " call pvmfpkmesgbody( bufid, info)"<Bar>echoh None<cr>
inorea pvmfpkmesg	pvmfpkmesg<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfpkmesg( bufid, info)"<Bar>echoh None<cr>
inorea pvmfprecv	pvmfprecv<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfprecv( tid, msgtag, buf, len, datatype, atid, atag, alen, info)"<Bar>echoh None<cr>
inorea pvmfprobe	pvmfprobe<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfprobe( tid, msgtag, bufid)"<Bar>echoh None<cr>
inorea pvmfpsend	pvmfpsend<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfpsend( tid, msgtag, buf, len, datatype, info)"<Bar>echoh None<cr>
inorea pvmfpstat	pvmfpstat<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfpstat( tid, status)"<Bar>echoh None<cr>
inorea pvmfputinfo	pvmfputinfo<c-o>:echoh HintHL<Bar>echo " call pvmfputinfo( name, bufid, flags, index)"<Bar>echoh None<cr>
inorea pvmfrecvinfo	pvmfrecvinfo<c-o>:echoh HintHL<Bar>echo " call pvmfrecvinfo( name, index, flags, bufid)"<Bar>echoh None<cr>
inorea pvmfrecv	pvmfrecv<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfrecv( tid, msgtag, bufid)"<Bar>echoh None<cr>
inorea pvmfreduce	pvmfreduce<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfreduce(func, data, count, datatype, msgtag, group, rootginst, info)"<Bar>echoh None<cr>
inorea pvmfscatter	pvmfscatter<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfscatter(result, data, count, datatype, msgtag, group, rootginst, info)"<Bar>echoh None<cr>
inorea pvmfsend	pvmfsend<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfsend( tid, msgtag, info)"<Bar>echoh None<cr>
inorea pvmfsendsig	pvmfsendsig<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfsendsig( tid, signum, info)"<Bar>echoh None<cr>
inorea pvmfserror	pvmfserror<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfserror( set, oldset)"<Bar>echoh None<cr>
inorea pvmfsetcontext	pvmfsetcontext<c-o>:echoh HintHL<Bar>echo " call pvmfsetcontext( new_ctx, old_ctx)"<Bar>echoh None<cr>
inorea pvmfsetopt	pvmfsetopt<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfsetopt( what, val, oldval)"<Bar>echoh None<cr>
inorea pvmfsetrbuf	pvmfsetrbuf<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfsetrbuf( bufid, oldbuf)"<Bar>echoh None<cr>
inorea pvmfsetsbuf	pvmfsetsbuf<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfsetsbuf( bufid, oldbuf)"<Bar>echoh None<cr>
inorea pvmfsiblings	pvmfsiblings<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfsiblings( ntids, index, sibling)"<Bar>echoh None<cr>
inorea pvmfspawn	pvmfspawn<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfspawn( task, flag, where, ntask, tids, numt)"<Bar>echoh None<cr>
inorea pvmfstartpvmd	pvmfstartpvmd<c-o>:echoh HintHL<Bar>echo "Fortran call pvmfstartpvmd( args, block, info)"<Bar>echoh None<cr>
inorea pvmftasks	pvmftasks<c-o>:echoh HintHL<Bar>echo "Fortran call pvmftasks( where, ntask, tid, ptid, dtid, flag, aout, info)"<Bar>echoh None<cr>
inorea pvmftidtoh	pvmftidtoh<c-o>:echoh HintHL<Bar>echo "Fortran call pvmftidtoh( tid, dtid)"<Bar>echoh None<cr>
inorea pvmftrecv	pvmftrecv<c-o>:echoh HintHL<Bar>echo "Fortran call pvmftrecv( tid, msgtag, sec, usec, bufid)"<Bar>echoh None<cr>
inorea pvmfunpack	pvmfunpack<c-o>:echoh HintHL<Bar>echo " call pvmfunpack( what, xp, nitem, stride, info)"<Bar>echoh None<cr>
inorea pvmfupkmesg	pvmfupkmesg<c-o>:echoh HintHL<Bar>echo " call pvmfupkmesg( bufid, newbufid)"<Bar>echoh None<cr>
inorea qecvt	qecvt<c-o>:echoh HintHL<Bar>echo "char *qecvt(long double number, int ndigits, int * decpt, int * sign)"<Bar>echoh None<cr>
inorea qecvt_r	qecvt_r<c-o>:echoh HintHL<Bar>echo "int qecvt_r(long double number, int ndigits, int * decpt, int * sign, char * buf, size_t len)"<Bar>echoh None<cr>
inorea qfcvt	qfcvt<c-o>:echoh HintHL<Bar>echo "char *qfcvt(long double number, int ndigits, int * decpt, int * sign)"<Bar>echoh None<cr>
inorea qfcvt_r	qfcvt_r<c-o>:echoh HintHL<Bar>echo "int qfcvt_r(long double number, int ndigits, int * decpt, int * sign, char * buf, size_t len)"<Bar>echoh None<cr>
inorea qgcvt	qgcvt<c-o>:echoh HintHL<Bar>echo "char *qgcvt(long double number, int ndigit, char * buf)"<Bar>echoh None<cr>
inorea qiflush	qiflush<c-o>:echoh HintHL<Bar>echo "void qiflush(void)"<Bar>echoh None<cr>
inorea query_user_context	query_user_context<c-o>:echoh HintHL<Bar>echo "int query_user_context(security_context_t * list, security_context_t * newcon)"<Bar>echoh None<cr>
inorea raise	raise<c-o>:echoh HintHL<Bar>echo "int raise(int sig)"<Bar>echoh None<cr>
inorea random	random<c-o>:echoh HintHL<Bar>echo "long int random(void)"<Bar>echoh None<cr>
inorea rand	rand<c-o>:echoh HintHL<Bar>echo "int rand(void)"<Bar>echoh None<cr>
inorea rand_r	rand_r<c-o>:echoh HintHL<Bar>echo "int rand_r(unsigned int * seedp)"<Bar>echoh None<cr>
inorea raw	raw<c-o>:echoh HintHL<Bar>echo "int raw(void)"<Bar>echoh None<cr>
inorea readdir	readdir<c-o>:echoh HintHL<Bar>echo "struct dirent *readdir(DIR * dir)"<Bar>echoh None<cr>
inorea realloc	realloc<c-o>:echoh HintHL<Bar>echo "void * realloc (void *ptr, size_t size)"<Bar>echoh None<cr>
inorea realloc	realloc<c-o>:echoh HintHL<Bar>echo "void *realloc(void *ptr, size_t size)"<Bar>echoh None<cr>
inorea re_comp	re_comp<c-o>:echoh HintHL<Bar>echo "char *re_comp(char * regex)"<Bar>echoh None<cr>
inorea redrawwin	redrawwin<c-o>:echoh HintHL<Bar>echo "int redrawwin(WINDOW *win)"<Bar>echoh None<cr>
inorea re_exec	re_exec<c-o>:echoh HintHL<Bar>echo "int re_exec(char * string)"<Bar>echoh None<cr>
inorea refresh	refresh<c-o>:echoh HintHL<Bar>echo "int refresh(void)"<Bar>echoh None<cr>
inorea remainderf	remainderf<c-o>:echoh HintHL<Bar>echo "float remainderf(float x, float y)"<Bar>echoh None<cr>
inorea remainderl	remainderl<c-o>:echoh HintHL<Bar>echo "long double remainderl(long double x, long double y)"<Bar>echoh None<cr>
inorea remainder	remainder<c-o>:echoh HintHL<Bar>echo "double remainder(double x, double y)"<Bar>echoh None<cr>
inorea remove	remove<c-o>:echoh HintHL<Bar>echo "int remove(const char * pathname)"<Bar>echoh None<cr>
inorea remque	remque<c-o>:echoh HintHL<Bar>echo "void remque(void * elem)"<Bar>echoh None<cr>
inorea remquof	remquof<c-o>:echoh HintHL<Bar>echo "float remquof(float x, float y, int * quo)"<Bar>echoh None<cr>
inorea remquol	remquol<c-o>:echoh HintHL<Bar>echo "long double remquol(long double x, long double y, int * quo)"<Bar>echoh None<cr>
inorea remquo	remquo<c-o>:echoh HintHL<Bar>echo "double remquo(double x, double y, int * quo)"<Bar>echoh None<cr>
inorea replace_panel	replace_panel<c-o>:echoh HintHL<Bar>echo "int replace_panel(PANEL *pan, WINDOW *window)"<Bar>echoh None<cr>
inorea request_init	request_init<c-o>:echoh HintHL<Bar>echo "struct request_info *request_init(request, key, value, ..., 0)"<Bar>echoh None<cr>
inorea request_set	request_set<c-o>:echoh HintHL<Bar>echo "struct request_info *request_set(request, key, value, ..., 0)"<Bar>echoh None<cr>
inorea reset_prog_mode	reset_prog_mode<c-o>:echoh HintHL<Bar>echo "int reset_prog_mode(void)"<Bar>echoh None<cr>
inorea reset_shell_mode	reset_shell_mode<c-o>:echoh HintHL<Bar>echo "int reset_shell_mode(void)"<Bar>echoh None<cr>
inorea resetty	resetty<c-o>:echoh HintHL<Bar>echo "int resetty(void)"<Bar>echoh None<cr>
inorea res_init	res_init<c-o>:echoh HintHL<Bar>echo "int res_init(void)"<Bar>echoh None<cr>
inorea resize_term	resize_term<c-o>:echoh HintHL<Bar>echo "int resize_term(int lines, int columns)"<Bar>echoh None<cr>
inorea resizeterm	resizeterm<c-o>:echoh HintHL<Bar>echo "int resizeterm(int lines, int columns)"<Bar>echoh None<cr>
inorea res_mkquery	res_mkquery<c-o>:echoh HintHL<Bar>echo "int res_mkquery(int op, const char * dname, int class, int type, char * data, int datalen, struct rrec * newrr, char * buf, int buflen)"<Bar>echoh None<cr>
inorea res_querydomain	res_querydomain<c-o>:echoh HintHL<Bar>echo "int res_querydomain(const char * name, const char * domain, int class, int type, unsigned char * answer, int anslen)"<Bar>echoh None<cr>
inorea res_query	res_query<c-o>:echoh HintHL<Bar>echo "int res_query(const char * dname, int class, int type, unsigned char * answer, int anslen)"<Bar>echoh None<cr>
inorea res_search	res_search<c-o>:echoh HintHL<Bar>echo "int res_search(const char * dname, int class, int type, unsigned char * answer, int anslen)"<Bar>echoh None<cr>
inorea res_send	res_send<c-o>:echoh HintHL<Bar>echo "int res_send(const char * msg, int msglen, char * answer, int anslen)"<Bar>echoh None<cr>
inorea restartterm	restartterm<c-o>:echoh HintHL<Bar>echo "int restartterm(const char *term, int fildes, int *errret)"<Bar>echoh None<cr>
inorea rewinddir	rewinddir<c-o>:echoh HintHL<Bar>echo "void rewinddir(DIR * dir)"<Bar>echoh None<cr>
inorea rewind	rewind<c-o>:echoh HintHL<Bar>echo "void rewind(FILE * stream)"<Bar>echoh None<cr>
inorea rindex	rindex<c-o>:echoh HintHL<Bar>echo "char *rindex(const char * s, int c)"<Bar>echoh None<cr>
inorea rintf	rintf<c-o>:echoh HintHL<Bar>echo "float rintf(float x)"<Bar>echoh None<cr>
inorea rintl	rintl<c-o>:echoh HintHL<Bar>echo "long double rintl(long double x)"<Bar>echoh None<cr>
inorea rint	rint<c-o>:echoh HintHL<Bar>echo "double rint(double x)"<Bar>echoh None<cr>
inorea ripoffline	ripoffline<c-o>:echoh HintHL<Bar>echo "int ripoffline(int line, int (*init)(WINDOW *, int))"<Bar>echoh None<cr>
inorea roundf	roundf<c-o>:echoh HintHL<Bar>echo "float roundf(float x)"<Bar>echoh None<cr>
inorea roundl	roundl<c-o>:echoh HintHL<Bar>echo "long double roundl(long double x)"<Bar>echoh None<cr>
inorea round	round<c-o>:echoh HintHL<Bar>echo "double round(double x)"<Bar>echoh None<cr>
inorea rpm_execcon	rpm_execcon<c-o>:echoh HintHL<Bar>echo "int rpm_execcon(unsigned int verified, const char * filename, char *const argv [], char *const envp [])"<Bar>echoh None<cr>
inorea rtime	rtime<c-o>:echoh HintHL<Bar>echo "int rtime(struct sockaddr_in * addrp, struct rpc_timeval * timep, struct rpc_timeval * timeout)"<Bar>echoh None<cr>
inorea sasl_auxprop_getctx	sasl_auxprop_getctx<c-o>:echoh HintHL<Bar>echo "int sasl_auxprop_getctx(sasl_conn_t *conn)"<Bar>echoh None<cr>
inorea sasl_canon_user_t	sasl_canon_user_t<c-o>:echoh HintHL<Bar>echo "int sasl_canon_user_t(sasl_conn_t *conn, void *context, const char *user, unsigned ulen, unsigned flags, const char *user_realm, char *out_user, unsigned out_umax, unsigned *out_ulen)"<Bar>echoh None<cr>
inorea sasl_chalprompt_t	sasl_chalprompt_t<c-o>:echoh HintHL<Bar>echo "int sasl_chalprompt_t(void *context, int id, const char *challenge, const char *prompt, const char *defresult, const char **result, unsigned *len)"<Bar>echoh None<cr>
inorea sasl_client_init	sasl_client_init<c-o>:echoh HintHL<Bar>echo "int sasl_client_init(const sasl_callback_t *callbacks)"<Bar>echoh None<cr>
inorea sasl_client_new	sasl_client_new<c-o>:echoh HintHL<Bar>echo "int sasl_client_new(const char *service, const char *serverFQDN, const char *iplocalport, const char *ipremoteport, const sasl_callback_t *prompt_supp, unsigned flags, sasl_conn_t ** pconn)"<Bar>echoh None<cr>
inorea sasl_client_start	sasl_client_start<c-o>:echoh HintHL<Bar>echo "int sasl_client_start(sasl_conn_t * conn, const char * mechlist, sasl_interact_t ** prompt_need, const char ** clientout, unsigned * clientoutlen, const char ** mech)"<Bar>echoh None<cr>
inorea sasl_client_step	sasl_client_step<c-o>:echoh HintHL<Bar>echo "int sasl_client_step(sasl_conn_t *conn, const char *serverin, unsigned serverinlen, sasl_interact_t ** prompt_need, const char ** clientout, unsigned * clientoutlen)"<Bar>echoh None<cr>
inorea sasl_dispose	sasl_dispose<c-o>:echoh HintHL<Bar>echo "void sasl_dispose( sasl_conn_t **pconn)"<Bar>echoh None<cr>
inorea sasl_done	sasl_done<c-o>:echoh HintHL<Bar>echo "void sasl_done( void)"<Bar>echoh None<cr>
inorea sasl_errdetail	sasl_errdetail<c-o>:echoh HintHL<Bar>echo "const char *sasl_errdetail( sasl_conn_t *conn)"<Bar>echoh None<cr>
inorea sasl_errstring	sasl_errstring<c-o>:echoh HintHL<Bar>echo "const char * sasl_errstring(int saslerr, const char * langlist, const char ** outlang)"<Bar>echoh None<cr>
inorea sasl_getopt_t	sasl_getopt_t<c-o>:echoh HintHL<Bar>echo "int sasl_getopt_t(void *context, const char *plugin_name, const char *option, const char ** result, unsigned * len)"<Bar>echoh None<cr>
inorea sasl_getpath_t	sasl_getpath_t<c-o>:echoh HintHL<Bar>echo "int sasl_getpath_t(void *context, char ** path)"<Bar>echoh None<cr>
inorea sasl_getrealm_t	sasl_getrealm_t<c-o>:echoh HintHL<Bar>echo "int sasl_getrealm_t(void *context, int id, const char **availrealms, const char **result)"<Bar>echoh None<cr>
inorea sasl_getsecret_t	sasl_getsecret_t<c-o>:echoh HintHL<Bar>echo "int sasl_getsecret_t(sasl_conn_t *conn, void *context, int id, sasl_secret_t ** psecret)"<Bar>echoh None<cr>
inorea sasl_getsimple_t	sasl_getsimple_t<c-o>:echoh HintHL<Bar>echo "int sasl_getsimple_t(void *context, int id, const char ** result, unsigned * len)"<Bar>echoh None<cr>
inorea sasl_global_listmech	sasl_global_listmech<c-o>:echoh HintHL<Bar>echo "const char ** sasl_global_listmech()"<Bar>echoh None<cr>
inorea sasl_idle	sasl_idle<c-o>:echoh HintHL<Bar>echo "int sasl_idle( sasl_conn_t *conn)"<Bar>echoh None<cr>
inorea sasl_listmech	sasl_listmech<c-o>:echoh HintHL<Bar>echo "int sasl_listmech(sasl_conn_t * conn, const char * user, const char * prefix, const char * sep, const char * suffix, const char ** result, unsigned * plen, int * pcount)"<Bar>echoh None<cr>
inorea sasl_log_t	sasl_log_t<c-o>:echoh HintHL<Bar>echo "int sasl_log_t(void *context, int level, const char * message)"<Bar>echoh None<cr>
inorea sasl_server_init	sasl_server_init<c-o>:echoh HintHL<Bar>echo "int sasl_server_init(const sasl_callback_t *callbacks, const char *appname)"<Bar>echoh None<cr>
inorea sasl_server_new	sasl_server_new<c-o>:echoh HintHL<Bar>echo "int sasl_server_new(const char *service, const char *serverFQDN, const char *user_realm, const char *iplocalport, const char *ipremoteport, const sasl_callback_t *callbacks, unsigned flags, sasl_conn_t ** pconn)"<Bar>echoh None<cr>
inorea sasl_server_start	sasl_server_start<c-o>:echoh HintHL<Bar>echo "int sasl_server_start(sasl_conn_t * conn, const char * mech, const char * clientin, unsigned * clientinlen, const char ** serverout, unsigned * serveroutlen)"<Bar>echoh None<cr>
inorea sasl_server_step	sasl_server_step<c-o>:echoh HintHL<Bar>echo "int sasl_server_step(sasl_conn_t *conn, const char *clientin, unsigned clientinlen, const char ** serverout, unsigned * serveroutlen)"<Bar>echoh None<cr>
inorea sasl_server_userdb_checkpass_t	sasl_server_userdb_checkpass_t<c-o>:echoh HintHL<Bar>echo "int sasl_server_userdb_checkpass_t(sasl_conn_t *conn, void *context, const char *user, const char *pass, unsigned passlen, struct propctx *propctx)"<Bar>echoh None<cr>
inorea sasl_server_userdb_setpass_t	sasl_server_userdb_setpass_t<c-o>:echoh HintHL<Bar>echo "int sasl_server_userdb_setpass_t(sasl_conn_t *conn, void *context, const char *user, const char *pass, unsigned passlen, struct propctx *propctx, unsigned flags)"<Bar>echoh None<cr>
inorea sasl_setpass	sasl_setpass<c-o>:echoh HintHL<Bar>echo "int sasl_setpass(sasl_conn_t * conn, const char * user, const char * pass, unsigned passlen, const char * oldpass, unsigned oldpasslen, unsigned flags)"<Bar>echoh None<cr>
inorea sasl_user_exists	sasl_user_exists<c-o>:echoh HintHL<Bar>echo "int sasl_user_exists( sasl_conn_t *conn, const char *service, const char *user_realm, const char *user)"<Bar>echoh None<cr>
inorea sasl_verifyfile_t	sasl_verifyfile_t<c-o>:echoh HintHL<Bar>echo "int sasl_verifyfile_t(void *context, const char *file, sasl_verify_type_t type)"<Bar>echoh None<cr>
inorea savetty	savetty<c-o>:echoh HintHL<Bar>echo "int savetty(void)"<Bar>echoh None<cr>
inorea scalbf	scalbf<c-o>:echoh HintHL<Bar>echo "float scalbf(float x, double exp)"<Bar>echoh None<cr>
inorea scalblnf	scalblnf<c-o>:echoh HintHL<Bar>echo "float scalblnf(float x, long int exp)"<Bar>echoh None<cr>
inorea scalblnl	scalblnl<c-o>:echoh HintHL<Bar>echo "long double scalblnl(long double x, long int exp)"<Bar>echoh None<cr>
inorea scalbln	scalbln<c-o>:echoh HintHL<Bar>echo "double scalbln(double x, long int exp)"<Bar>echoh None<cr>
inorea scalbl	scalbl<c-o>:echoh HintHL<Bar>echo "long double scalbl(long double x, double exp)"<Bar>echoh None<cr>
inorea scalbnf	scalbnf<c-o>:echoh HintHL<Bar>echo "float scalbnf(float x, int exp)"<Bar>echoh None<cr>
inorea scalbnl	scalbnl<c-o>:echoh HintHL<Bar>echo "long double scalbnl(long double x, int exp)"<Bar>echoh None<cr>
inorea scalbn	scalbn<c-o>:echoh HintHL<Bar>echo "double scalbn(double x, int exp)"<Bar>echoh None<cr>
inorea scalb	scalb<c-o>:echoh HintHL<Bar>echo "double scalb(double x, double exp)"<Bar>echoh None<cr>
inorea scale_form	scale_form<c-o>:echoh HintHL<Bar>echo "int scale_form(const FORM *form, int *rows, int *columns)"<Bar>echoh None<cr>
inorea scale_menu	scale_menu<c-o>:echoh HintHL<Bar>echo "int scale_menu(const MENU *menu, int *rows, int *columns)"<Bar>echoh None<cr>
inorea scandir	scandir<c-o>:echoh HintHL<Bar>echo "int scandir(const char * dir, struct dirent *** namelist, int(* filter)(const struct dirent *), int(* compar)(const struct dirent **, const struct dirent **))"<Bar>echoh None<cr>
inorea scanf	scanf<c-o>:echoh HintHL<Bar>echo "int scanf(const char * format, ...)"<Bar>echoh None<cr>
inorea scanw	scanw<c-o>:echoh HintHL<Bar>echo "int scanw(char *fmt, ...)"<Bar>echoh None<cr>
inorea scr_dump	scr_dump<c-o>:echoh HintHL<Bar>echo "int scr_dump(const char *filename)"<Bar>echoh None<cr>
inorea scr_init	scr_init<c-o>:echoh HintHL<Bar>echo "int scr_init(const char *filename)"<Bar>echoh None<cr>
inorea scrl	scrl<c-o>:echoh HintHL<Bar>echo "int scrl(int n)"<Bar>echoh None<cr>
inorea scrollok	scrollok<c-o>:echoh HintHL<Bar>echo "int scrollok(WINDOW *win, bool bf)"<Bar>echoh None<cr>
inorea scroll	scroll<c-o>:echoh HintHL<Bar>echo "int scroll(WINDOW *win)"<Bar>echoh None<cr>
inorea scr_restore	scr_restore<c-o>:echoh HintHL<Bar>echo "int scr_restore(const char *filename)"<Bar>echoh None<cr>
inorea scr_set	scr_set<c-o>:echoh HintHL<Bar>echo "int scr_set(const char *filename)"<Bar>echoh None<cr>
inorea security_check_context	security_check_context<c-o>:echoh HintHL<Bar>echo "int security_check_context(security_context_t con)"<Bar>echoh None<cr>
inorea security_commit_booleans	security_commit_booleans<c-o>:echoh HintHL<Bar>echo "extern int security_commit_booleans(void)"<Bar>echoh None<cr>
inorea security_compute_av	security_compute_av<c-o>:echoh HintHL<Bar>echo "int security_compute_av(security_context_t scon, security_context_t tcon, security_class_t tclass, access_vector_t requested, struct av_decision * avd)"<Bar>echoh None<cr>
inorea security_compute_create	security_compute_create<c-o>:echoh HintHL<Bar>echo "int security_compute_create(security_context_t scon, security_context_t tcon, security_class_t tclass, security_context_t * newcon)"<Bar>echoh None<cr>
inorea security_compute_relabel	security_compute_relabel<c-o>:echoh HintHL<Bar>echo "int security_compute_relabel(security_context_t scon, security_context_t tcon, security_class_t tclass, security_context_t * newcon)"<Bar>echoh None<cr>
inorea security_compute_user	security_compute_user<c-o>:echoh HintHL<Bar>echo "int security_compute_user(security_context_t scon, const char * username, security_context_t ** con)"<Bar>echoh None<cr>
inorea security_get_boolean_active	security_get_boolean_active<c-o>:echoh HintHL<Bar>echo "extern int security_get_boolean_active(const char *name)"<Bar>echoh None<cr>
inorea security_get_boolean_names	security_get_boolean_names<c-o>:echoh HintHL<Bar>echo "extern int security_get_boolean_names(char ***names, int *len)"<Bar>echoh None<cr>
inorea security_get_boolean_pending	security_get_boolean_pending<c-o>:echoh HintHL<Bar>echo "extern int security_get_boolean_pending(const char *name)"<Bar>echoh None<cr>
inorea security_getenforce	security_getenforce<c-o>:echoh HintHL<Bar>echo "int security_getenforce()"<Bar>echoh None<cr>
inorea security_load_booleans	security_load_booleans<c-o>:echoh HintHL<Bar>echo "extern int security_load_booleans(char *path)"<Bar>echoh None<cr>
inorea security_load_policy	security_load_policy<c-o>:echoh HintHL<Bar>echo "int security_load_policy(void * data, size_t len)"<Bar>echoh None<cr>
inorea security_policyvers	security_policyvers<c-o>:echoh HintHL<Bar>echo "int security_policyvers()"<Bar>echoh None<cr>
inorea security_set_boolean	security_set_boolean<c-o>:echoh HintHL<Bar>echo "extern int security_set_boolean(const char *name, int value)"<Bar>echoh None<cr>
inorea security_setenforce	security_setenforce<c-o>:echoh HintHL<Bar>echo "int security_setenforce(int value)"<Bar>echoh None<cr>
inorea seed48_r	seed48_r<c-o>:echoh HintHL<Bar>echo "int seed48_r(unsigned short int seed16v[3], struct drand48_data * buffer)"<Bar>echoh None<cr>
inorea seed48	seed48<c-o>:echoh HintHL<Bar>echo "unsigned short *seed48(unsigned short seed16v [3])"<Bar>echoh None<cr>
inorea seekdir	seekdir<c-o>:echoh HintHL<Bar>echo "void seekdir(DIR * dir, off_t offset)"<Bar>echoh None<cr>
inorea selinux_binary_policy_path	selinux_binary_policy_path<c-o>:echoh HintHL<Bar>echo "extern const char *selinux_binary_policy_path(void)"<Bar>echoh None<cr>
inorea selinux_booleans_path	selinux_booleans_path<c-o>:echoh HintHL<Bar>echo "extern const char *selinux_booleans_path(void)"<Bar>echoh None<cr>
inorea selinux_contexts_path	selinux_contexts_path<c-o>:echoh HintHL<Bar>echo "extern const char *selinux_contexts_path(void)"<Bar>echoh None<cr>
inorea selinux_default_context_path	selinux_default_context_path<c-o>:echoh HintHL<Bar>echo "extern const char *selinux_default_context_path(void)"<Bar>echoh None<cr>
inorea selinux_failsafe_context_path	selinux_failsafe_context_path<c-o>:echoh HintHL<Bar>echo "extern const char *selinux_failsafe_context_path(void)"<Bar>echoh None<cr>
inorea selinux_file_context_path	selinux_file_context_path<c-o>:echoh HintHL<Bar>echo "extern const char *selinux_file_context_path(void)"<Bar>echoh None<cr>
inorea selinux_getenforcemode	selinux_getenforcemode<c-o>:echoh HintHL<Bar>echo "int selinux_getenforcemode(int *enforce)"<Bar>echoh None<cr>
inorea selinux_media_context_path	selinux_media_context_path<c-o>:echoh HintHL<Bar>echo "extern const char *selinux_media_context_path(void)"<Bar>echoh None<cr>
inorea selinux_policy_root	selinux_policy_root<c-o>:echoh HintHL<Bar>echo "char *selinux_policy_root()"<Bar>echoh None<cr>
inorea selinux_policy_root	selinux_policy_root<c-o>:echoh HintHL<Bar>echo "extern const char *selinux_policy_root(void)"<Bar>echoh None<cr>
inorea selinux_removable_context_path	selinux_removable_context_path<c-o>:echoh HintHL<Bar>echo "extern const char *selinux_removable_context_path(void)"<Bar>echoh None<cr>
inorea selinux_user_contexts_path	selinux_user_contexts_path<c-o>:echoh HintHL<Bar>echo "extern const char *selinux_user_contexts_path(void)"<Bar>echoh None<cr>
inorea setaliasent	setaliasent<c-o>:echoh HintHL<Bar>echo "void setaliasent(void)"<Bar>echoh None<cr>
inorea setbuffer	setbuffer<c-o>:echoh HintHL<Bar>echo "void setbuffer(FILE * stream, char * buf, size_t size)"<Bar>echoh None<cr>
inorea setbuf	setbuf<c-o>:echoh HintHL<Bar>echo "void setbuf(FILE * stream, char * buf)"<Bar>echoh None<cr>
inorea setcon	setcon<c-o>:echoh HintHL<Bar>echo "int setcon(security_context_t context)"<Bar>echoh None<cr>
inorea set_current_field	set_current_field<c-o>:echoh HintHL<Bar>echo "int set_current_field(FORM *form, FIELD *field)"<Bar>echoh None<cr>
inorea set_current_item	set_current_item<c-o>:echoh HintHL<Bar>echo "int set_current_item(MENU *menu, const ITEM *item)"<Bar>echoh None<cr>
inorea set_curterm	set_curterm<c-o>:echoh HintHL<Bar>echo "TERMINAL *set_curterm(TERMINAL *nterm)"<Bar>echoh None<cr>
inorea setenv	setenv<c-o>:echoh HintHL<Bar>echo "int setenv(const char * name, const char * value, int overwrite)"<Bar>echoh None<cr>
inorea setexeccon	setexeccon<c-o>:echoh HintHL<Bar>echo "int setexeccon(security_context_t context)"<Bar>echoh None<cr>
inorea set_field_back	set_field_back<c-o>:echoh HintHL<Bar>echo "int set_field_back(FIELD *field, chtype attr)"<Bar>echoh None<cr>
inorea set_field_buffer	set_field_buffer<c-o>:echoh HintHL<Bar>echo "int set_field_buffer(FIELD *field, int buf, const char *value)"<Bar>echoh None<cr>
inorea set_field_fore	set_field_fore<c-o>:echoh HintHL<Bar>echo "int set_field_fore(FIELD *field, chtype attr)"<Bar>echoh None<cr>
inorea set_field_init	set_field_init<c-o>:echoh HintHL<Bar>echo "int set_field_init(FORM *form, void (*func)(FORM *))"<Bar>echoh None<cr>
inorea set_field_just	set_field_just<c-o>:echoh HintHL<Bar>echo "int set_field_just(FIELD *field, int justification)"<Bar>echoh None<cr>
inorea set_field_opts	set_field_opts<c-o>:echoh HintHL<Bar>echo "int set_field_opts(FIELD *field, OPTIONS opts)"<Bar>echoh None<cr>
inorea set_field_pad	set_field_pad<c-o>:echoh HintHL<Bar>echo "int set_field_pad(FIELD *field, int pad)"<Bar>echoh None<cr>
inorea set_field_status	set_field_status<c-o>:echoh HintHL<Bar>echo "int set_field_status(FIELD *field, bool status)"<Bar>echoh None<cr>
inorea set_field_term	set_field_term<c-o>:echoh HintHL<Bar>echo "int set_field_term(FORM *form, void (*func)(FORM *))"<Bar>echoh None<cr>
inorea set_field_type	set_field_type<c-o>:echoh HintHL<Bar>echo "int set_field_type(FIELD *field, FIELDTYPE *type, ...)"<Bar>echoh None<cr>
inorea set_field_userptr	set_field_userptr<c-o>:echoh HintHL<Bar>echo "int set_field_userptr(FIELD *field, void*userptr)"<Bar>echoh None<cr>
inorea setfilecon	setfilecon<c-o>:echoh HintHL<Bar>echo "int setfilecon(const char * path, security_context_t con)"<Bar>echoh None<cr>
inorea set_form_fields	set_form_fields<c-o>:echoh HintHL<Bar>echo "int set_form_fields(FORM *form, FIELD **fields)"<Bar>echoh None<cr>
inorea set_form_init	set_form_init<c-o>:echoh HintHL<Bar>echo "int set_form_init(FORM *form, void (*func)(FORM *))"<Bar>echoh None<cr>
inorea set_form_opts	set_form_opts<c-o>:echoh HintHL<Bar>echo "int set_form_opts(FORM *form, OPTIONS opts)"<Bar>echoh None<cr>
inorea set_form_page	set_form_page<c-o>:echoh HintHL<Bar>echo "int set_form_page(FORM *form, int n)"<Bar>echoh None<cr>
inorea set_form_sub	set_form_sub<c-o>:echoh HintHL<Bar>echo "int set_form_sub(FORM *form, WINDOW *sub)"<Bar>echoh None<cr>
inorea set_form_term	set_form_term<c-o>:echoh HintHL<Bar>echo "int set_form_term(FORM *form, void (*func)(FORM *))"<Bar>echoh None<cr>
inorea set_form_userptr	set_form_userptr<c-o>:echoh HintHL<Bar>echo "int set_form_userptr(FORM *form, void *userptr)"<Bar>echoh None<cr>
inorea set_form_win	set_form_win<c-o>:echoh HintHL<Bar>echo "int set_form_win(FORM *form, WINDOW *win)"<Bar>echoh None<cr>
inorea __setfpucw	__setfpucw<c-o>:echoh HintHL<Bar>echo "void __setfpucw((unsigned short) control_word)"<Bar>echoh None<cr>
inorea setfscreatecon	setfscreatecon<c-o>:echoh HintHL<Bar>echo "int setfscreatecon(security_context_t context)"<Bar>echoh None<cr>
inorea setfsent	setfsent<c-o>:echoh HintHL<Bar>echo "int setfsent(void)"<Bar>echoh None<cr>
inorea setgrent	setgrent<c-o>:echoh HintHL<Bar>echo "void setgrent(void)"<Bar>echoh None<cr>
inorea sethostent	sethostent<c-o>:echoh HintHL<Bar>echo "void sethostent(int stayopen)"<Bar>echoh None<cr>
inorea set_item_init	set_item_init<c-o>:echoh HintHL<Bar>echo "int set_item_init(MENU *menu, void (*func)(MENU *))"<Bar>echoh None<cr>
inorea set_item_opts	set_item_opts<c-o>:echoh HintHL<Bar>echo "int set_item_opts(ITEM *item, OPTIONS opts)"<Bar>echoh None<cr>
inorea set_item_term	set_item_term<c-o>:echoh HintHL<Bar>echo "int set_item_term(MENU *menu, void (*func)(MENU *))"<Bar>echoh None<cr>
inorea set_item_userptr	set_item_userptr<c-o>:echoh HintHL<Bar>echo "int set_item_userptr(ITEM *item, void *userptr)"<Bar>echoh None<cr>
inorea set_item_value	set_item_value<c-o>:echoh HintHL<Bar>echo "int set_item_value(ITEM *item, bool value)"<Bar>echoh None<cr>
inorea setjmp	setjmp<c-o>:echoh HintHL<Bar>echo "int setjmp(jmp_buf env)"<Bar>echoh None<cr>
inorea setkey_r	setkey_r<c-o>:echoh HintHL<Bar>echo "void setkey_r (const char * key, struct crypt_data * data)"<Bar>echoh None<cr>
inorea setkey	setkey<c-o>:echoh HintHL<Bar>echo "void setkey(const char * key)"<Bar>echoh None<cr>
inorea setlinebuf	setlinebuf<c-o>:echoh HintHL<Bar>echo "void setlinebuf(FILE * stream)"<Bar>echoh None<cr>
inorea setlocale	setlocale<c-o>:echoh HintHL<Bar>echo "char *setlocale(int category, const char * locale)"<Bar>echoh None<cr>
inorea setlogmask	setlogmask<c-o>:echoh HintHL<Bar>echo "int setlogmask(int mask)"<Bar>echoh None<cr>
inorea set_matchpathcon_flags	set_matchpathcon_flags<c-o>:echoh HintHL<Bar>echo "void set_matchpathcon_flags(unsigned int flags)"<Bar>echoh None<cr>
inorea set_matchpathcon_invalidcon	set_matchpathcon_invalidcon<c-o>:echoh HintHL<Bar>echo "void set_matchpathcon_invalidcon(int (* f)(const char *path, unsigned lineno, char * context))"<Bar>echoh None<cr>
inorea set_matchpathcon_printf	set_matchpathcon_printf<c-o>:echoh HintHL<Bar>echo "void set_matchpathcon_printf(void (* f)(const char * fmt, ...))"<Bar>echoh None<cr>
inorea set_max_field	set_max_field<c-o>:echoh HintHL<Bar>echo "int set_max_field(FIELD *field, int max)"<Bar>echoh None<cr>
inorea set_menu_back	set_menu_back<c-o>:echoh HintHL<Bar>echo "int set_menu_back(MENU *menu, chtype attr)"<Bar>echoh None<cr>
inorea set_menu_fore	set_menu_fore<c-o>:echoh HintHL<Bar>echo "int set_menu_fore(MENU *menu, chtype attr)"<Bar>echoh None<cr>
inorea set_menu_format	set_menu_format<c-o>:echoh HintHL<Bar>echo "int set_menu_format(MENU *menu, int rows, int cols)"<Bar>echoh None<cr>
inorea set_menu_grey	set_menu_grey<c-o>:echoh HintHL<Bar>echo "int set_menu_grey(MENU *menu, chtype attr)"<Bar>echoh None<cr>
inorea set_menu_init	set_menu_init<c-o>:echoh HintHL<Bar>echo "int set_menu_init(MENU *menu, void (*func)(MENU *))"<Bar>echoh None<cr>
inorea set_menu_items	set_menu_items<c-o>:echoh HintHL<Bar>echo "int set_menu_items(MENU *menu, ITEM **items)"<Bar>echoh None<cr>
inorea set_menu_mark	set_menu_mark<c-o>:echoh HintHL<Bar>echo "int set_menu_mark(MENU *menu, const char *mark)"<Bar>echoh None<cr>
inorea set_menu_opts	set_menu_opts<c-o>:echoh HintHL<Bar>echo "int set_menu_opts(MENU *menu, OPTIONS opts)"<Bar>echoh None<cr>
inorea set_menu_pad	set_menu_pad<c-o>:echoh HintHL<Bar>echo "int set_menu_pad(MENU *menu, int pad)"<Bar>echoh None<cr>
inorea set_menu_pattern	set_menu_pattern<c-o>:echoh HintHL<Bar>echo "int set_menu_pattern(MENU *menu, const char *pattern)"<Bar>echoh None<cr>
inorea set_menu_spacing	set_menu_spacing<c-o>:echoh HintHL<Bar>echo "int set_menu_spacing(MENU *menu, int spc_description, int spc_rows, int spc_columns)"<Bar>echoh None<cr>
inorea set_menu_sub	set_menu_sub<c-o>:echoh HintHL<Bar>echo "int set_menu_sub(MENU *menu, WINDOW *sub)"<Bar>echoh None<cr>
inorea set_menu_term	set_menu_term<c-o>:echoh HintHL<Bar>echo "int set_menu_term(MENU *menu, void (*func)(MENU *))"<Bar>echoh None<cr>
inorea set_menu_userptr	set_menu_userptr<c-o>:echoh HintHL<Bar>echo "int set_menu_userptr(MENU *menu, void *userptr)"<Bar>echoh None<cr>
inorea set_menu_win	set_menu_win<c-o>:echoh HintHL<Bar>echo "int set_menu_win(MENU *menu, WINDOW *win)"<Bar>echoh None<cr>
inorea setmntent	setmntent<c-o>:echoh HintHL<Bar>echo "FILE *setmntent(const char * filename, const char * type)"<Bar>echoh None<cr>
inorea setnetent	setnetent<c-o>:echoh HintHL<Bar>echo "void setnetent(int stayopen)"<Bar>echoh None<cr>
inorea setnetgrent	setnetgrent<c-o>:echoh HintHL<Bar>echo "int setnetgrent(const char * netgroup)"<Bar>echoh None<cr>
inorea set_new_page	set_new_page<c-o>:echoh HintHL<Bar>echo "int set_new_page(FIELD *field, bool new_page_flag)"<Bar>echoh None<cr>
inorea set_panel_userptr	set_panel_userptr<c-o>:echoh HintHL<Bar>echo "int set_panel_userptr(PANEL *pan, const void *ptr)"<Bar>echoh None<cr>
inorea setprotoent	setprotoent<c-o>:echoh HintHL<Bar>echo "void setprotoent(int stayopen)"<Bar>echoh None<cr>
inorea setpwent	setpwent<c-o>:echoh HintHL<Bar>echo "void setpwent(void)"<Bar>echoh None<cr>
inorea setrpcent	setrpcent<c-o>:echoh HintHL<Bar>echo "setrpcent (stayopen)"<Bar>echoh None<cr>
inorea setscrreg	setscrreg<c-o>:echoh HintHL<Bar>echo "int setscrreg(int top, int bot)"<Bar>echoh None<cr>
inorea setservent	setservent<c-o>:echoh HintHL<Bar>echo "void setservent(int stayopen)"<Bar>echoh None<cr>
inorea setstate	setstate<c-o>:echoh HintHL<Bar>echo "char *setstate(char * state)"<Bar>echoh None<cr>
inorea setsyx	setsyx<c-o>:echoh HintHL<Bar>echo "void setsyx(int y, int x)"<Bar>echoh None<cr>
inorea setterm	setterm<c-o>:echoh HintHL<Bar>echo "int setterm(char *term)"<Bar>echoh None<cr>
inorea set_term	set_term<c-o>:echoh HintHL<Bar>echo "SCREEN *set_term(SCREEN *new)"<Bar>echoh None<cr>
inorea set_top_row	set_top_row<c-o>:echoh HintHL<Bar>echo "int set_top_row(MENU *menu, int row)"<Bar>echoh None<cr>
inorea setttyent	setttyent<c-o>:echoh HintHL<Bar>echo "int setttyent(void)"<Bar>echoh None<cr>
inorea setupterm	setupterm<c-o>:echoh HintHL<Bar>echo "int setupterm(char *term, int fildes, int *errret)"<Bar>echoh None<cr>
inorea setusershell	setusershell<c-o>:echoh HintHL<Bar>echo "void setusershell(void)"<Bar>echoh None<cr>
inorea setutent	setutent<c-o>:echoh HintHL<Bar>echo "void setutent(void)"<Bar>echoh None<cr>
inorea shm_open	shm_open<c-o>:echoh HintHL<Bar>echo "int shm_open(const char * name, int oflag, mode_t mode)"<Bar>echoh None<cr>
inorea shm_unlink	shm_unlink<c-o>:echoh HintHL<Bar>echo "int shm_unlink(const char * name)"<Bar>echoh None<cr>
inorea show_panel	show_panel<c-o>:echoh HintHL<Bar>echo "int show_panel(PANEL *pan)"<Bar>echoh None<cr>
inorea sidget	sidget<c-o>:echoh HintHL<Bar>echo "int sidget(security_id_t sid)"<Bar>echoh None<cr>
inorea sidput	sidput<c-o>:echoh HintHL<Bar>echo "int sidput(security_id_t sid)"<Bar>echoh None<cr>
inorea sigaddset	sigaddset<c-o>:echoh HintHL<Bar>echo "int sigaddset(sigset_t * set, int signum)"<Bar>echoh None<cr>
inorea sigblock	sigblock<c-o>:echoh HintHL<Bar>echo "int sigblock(int mask)"<Bar>echoh None<cr>
inorea sigdelset	sigdelset<c-o>:echoh HintHL<Bar>echo "int sigdelset(sigset_t * set, int signum)"<Bar>echoh None<cr>
inorea sigemptyset	sigemptyset<c-o>:echoh HintHL<Bar>echo "int sigemptyset(sigset_t * set)"<Bar>echoh None<cr>
inorea sigfillset	sigfillset<c-o>:echoh HintHL<Bar>echo "int sigfillset(sigset_t * set)"<Bar>echoh None<cr>
inorea siggetmask	siggetmask<c-o>:echoh HintHL<Bar>echo "int siggetmask(void)"<Bar>echoh None<cr>
inorea sighold	sighold<c-o>:echoh HintHL<Bar>echo "int sighold(int sig)"<Bar>echoh None<cr>
inorea sigignore	sigignore<c-o>:echoh HintHL<Bar>echo "int sigignore(int sig)"<Bar>echoh None<cr>
inorea siginterrupt	siginterrupt<c-o>:echoh HintHL<Bar>echo "int siginterrupt(int sig, int flag)"<Bar>echoh None<cr>
inorea sigismember	sigismember<c-o>:echoh HintHL<Bar>echo "int sigismember(const sigset_t * set, int signum)"<Bar>echoh None<cr>
inorea siglongjmp	siglongjmp<c-o>:echoh HintHL<Bar>echo "void siglongjmp(sigjmp_buf env, int val)"<Bar>echoh None<cr>
inorea sigmask	sigmask<c-o>:echoh HintHL<Bar>echo "int sigmask(int signum)"<Bar>echoh None<cr>
inorea signbit	signbit<c-o>:echoh HintHL<Bar>echo "int signbit ( X)"<Bar>echoh None<cr>
inorea significandf	significandf<c-o>:echoh HintHL<Bar>echo "float significandf(float x)"<Bar>echoh None<cr>
inorea significandl	significandl<c-o>:echoh HintHL<Bar>echo "long double significandl(long double x)"<Bar>echoh None<cr>
inorea significand	significand<c-o>:echoh HintHL<Bar>echo "double significand(double x)"<Bar>echoh None<cr>
inorea sigrelse	sigrelse<c-o>:echoh HintHL<Bar>echo "int sigrelse(int sig)"<Bar>echoh None<cr>
inorea sigsetjmp	sigsetjmp<c-o>:echoh HintHL<Bar>echo "int sigsetjmp(sigjmp_buf env, int savesigs)"<Bar>echoh None<cr>
inorea sigsetmask	sigsetmask<c-o>:echoh HintHL<Bar>echo "int sigsetmask(int mask)"<Bar>echoh None<cr>
inorea sigset	sigset<c-o>:echoh HintHL<Bar>echo "sighandler_t sigset(int sig, sighandler_t disp)"<Bar>echoh None<cr>
inorea sigvec	sigvec<c-o>:echoh HintHL<Bar>echo "int sigvec(int sig, struct sigvec * vec, struct sigvec * ovec)"<Bar>echoh None<cr>
inorea sincosf	sincosf<c-o>:echoh HintHL<Bar>echo "void sincosf(float x, float * sin, float * cos)"<Bar>echoh None<cr>
inorea sincosl	sincosl<c-o>:echoh HintHL<Bar>echo "void sincosl(long double x, long double * sin, long double * cos)"<Bar>echoh None<cr>
inorea sincos	sincos<c-o>:echoh HintHL<Bar>echo "void sincos(double x, double * sin, double * cos)"<Bar>echoh None<cr>
inorea sinf	sinf<c-o>:echoh HintHL<Bar>echo "float sinf(float x)"<Bar>echoh None<cr>
inorea sinhf	sinhf<c-o>:echoh HintHL<Bar>echo "float sinhf(float x)"<Bar>echoh None<cr>
inorea sinhl	sinhl<c-o>:echoh HintHL<Bar>echo "long double sinhl(long double x)"<Bar>echoh None<cr>
inorea sinh	sinh<c-o>:echoh HintHL<Bar>echo "double sinh(double x)"<Bar>echoh None<cr>
inorea sinl	sinl<c-o>:echoh HintHL<Bar>echo "long double sinl(long double x)"<Bar>echoh None<cr>
inorea sin	sin<c-o>:echoh HintHL<Bar>echo "double sin(double x)"<Bar>echoh None<cr>
inorea sleep	sleep<c-o>:echoh HintHL<Bar>echo "unsigned int sleep(unsigned int seconds)"<Bar>echoh None<cr>
inorea slk_attr_off	slk_attr_off<c-o>:echoh HintHL<Bar>echo "int slk_attr_off(const attr_t attrs, void * opts)"<Bar>echoh None<cr>
inorea slk_attroff	slk_attroff<c-o>:echoh HintHL<Bar>echo "int slk_attroff(const chtype attrs)"<Bar>echoh None<cr>
inorea slk_attr_on	slk_attr_on<c-o>:echoh HintHL<Bar>echo "int slk_attr_on(attr_t attrs, void* opts)"<Bar>echoh None<cr>
inorea slk_attron	slk_attron<c-o>:echoh HintHL<Bar>echo "int slk_attron(const chtype attrs)"<Bar>echoh None<cr>
inorea slk_attr_set	slk_attr_set<c-o>:echoh HintHL<Bar>echo "int slk_attr_set(const attr_t attrs, short color_pair_number, void* opts)"<Bar>echoh None<cr>
inorea slk_attrset	slk_attrset<c-o>:echoh HintHL<Bar>echo "int slk_attrset(const chtype attrs)"<Bar>echoh None<cr>
inorea slk_attr	slk_attr<c-o>:echoh HintHL<Bar>echo "attr_t slk_attr(void)"<Bar>echoh None<cr>
inorea slk_clear	slk_clear<c-o>:echoh HintHL<Bar>echo "int slk_clear(void)"<Bar>echoh None<cr>
inorea slk_color	slk_color<c-o>:echoh HintHL<Bar>echo "int slk_color(short color_pair_number)"<Bar>echoh None<cr>
inorea slk_init	slk_init<c-o>:echoh HintHL<Bar>echo "int slk_init(int fmt)"<Bar>echoh None<cr>
inorea slk_label	slk_label<c-o>:echoh HintHL<Bar>echo "char *slk_label(int labnum)"<Bar>echoh None<cr>
inorea slk_noutrefresh	slk_noutrefresh<c-o>:echoh HintHL<Bar>echo "int slk_noutrefresh(void)"<Bar>echoh None<cr>
inorea slk_refresh	slk_refresh<c-o>:echoh HintHL<Bar>echo "int slk_refresh(void)"<Bar>echoh None<cr>
inorea slk_restore	slk_restore<c-o>:echoh HintHL<Bar>echo "int slk_restore(void)"<Bar>echoh None<cr>
inorea slk_set	slk_set<c-o>:echoh HintHL<Bar>echo "int slk_set(int labnum, const char *label, int fmt)"<Bar>echoh None<cr>
inorea slk_touch	slk_touch<c-o>:echoh HintHL<Bar>echo "int slk_touch(void)"<Bar>echoh None<cr>
inorea SMIME_write_PKCS7	SMIME_write_PKCS7<c-o>:echoh HintHL<Bar>echo "int SMIME_write_PKCS7(\s-1BIO\s0 *out, \s-1PKCS7\s0 *p7, \s-1BIO\s0 *data, int flags)"<Bar>echoh None<cr>
inorea snprintf	snprintf<c-o>:echoh HintHL<Bar>echo "int snprintf(char * str, size_t size, const char * format, ...)"<Bar>echoh None<cr>
inorea sprintf	sprintf<c-o>:echoh HintHL<Bar>echo "int sprintf(char * str, const char * format, ...)"<Bar>echoh None<cr>
inorea sqrtf	sqrtf<c-o>:echoh HintHL<Bar>echo "float sqrtf(float x)"<Bar>echoh None<cr>
inorea sqrtl	sqrtl<c-o>:echoh HintHL<Bar>echo "long double sqrtl(long double x)"<Bar>echoh None<cr>
inorea sqrt	sqrt<c-o>:echoh HintHL<Bar>echo "double sqrt(double x)"<Bar>echoh None<cr>
inorea srand48_r	srand48_r<c-o>:echoh HintHL<Bar>echo "int srand48_r(long int seedval, struct drand48_data * buffer)"<Bar>echoh None<cr>
inorea srand48	srand48<c-o>:echoh HintHL<Bar>echo "void srand48(long int seedval)"<Bar>echoh None<cr>
inorea srandom	srandom<c-o>:echoh HintHL<Bar>echo "void srandom(unsigned int seed)"<Bar>echoh None<cr>
inorea srand	srand<c-o>:echoh HintHL<Bar>echo "void srand(unsigned int seed)"<Bar>echoh None<cr>
inorea sscanf	sscanf<c-o>:echoh HintHL<Bar>echo "int sscanf(const char * str, const char * format, ...)"<Bar>echoh None<cr>
inorea ssignal	ssignal<c-o>:echoh HintHL<Bar>echo "sighandler_t ssignal(int signum, sighandler_t action)"<Bar>echoh None<cr>
inorea standend	standend<c-o>:echoh HintHL<Bar>echo "int standend(void)"<Bar>echoh None<cr>
inorea standout	standout<c-o>:echoh HintHL<Bar>echo "int standout(void)"<Bar>echoh None<cr>
inorea start_color	start_color<c-o>:echoh HintHL<Bar>echo "int start_color(void)"<Bar>echoh None<cr>
inorea store	store<c-o>:echoh HintHL<Bar>echo "store (key, content)"<Bar>echoh None<cr>
inorea stpcpy	stpcpy<c-o>:echoh HintHL<Bar>echo "char *stpcpy(char * dest, const char * src)"<Bar>echoh None<cr>
inorea stpncpy	stpncpy<c-o>:echoh HintHL<Bar>echo "char *stpncpy(char * dest, const char * src, size_t n)"<Bar>echoh None<cr>
inorea strcasecmp	strcasecmp<c-o>:echoh HintHL<Bar>echo "int strcasecmp(const char * s1, const char * s2)"<Bar>echoh None<cr>
inorea strcasestr	strcasestr<c-o>:echoh HintHL<Bar>echo "char *strcasestr(const char * haystack, const char * needle)"<Bar>echoh None<cr>
inorea strcat	strcat<c-o>:echoh HintHL<Bar>echo "char *strcat(char * dest, const char * src)"<Bar>echoh None<cr>
inorea strchr	strchr<c-o>:echoh HintHL<Bar>echo "char *strchr(const char * s, int c)"<Bar>echoh None<cr>
inorea strcmp	strcmp<c-o>:echoh HintHL<Bar>echo "int strcmp(const char * s1, const char * s2)"<Bar>echoh None<cr>
inorea strcoll	strcoll<c-o>:echoh HintHL<Bar>echo "int strcoll(const char * s1, const char * s2)"<Bar>echoh None<cr>
inorea strcpy	strcpy<c-o>:echoh HintHL<Bar>echo "char *strcpy(char * dest, const char * src)"<Bar>echoh None<cr>
inorea strcspn	strcspn<c-o>:echoh HintHL<Bar>echo "size_t strcspn(const char * s, const char * reject)"<Bar>echoh None<cr>
inorea strdupa	strdupa<c-o>:echoh HintHL<Bar>echo "char *strdupa(const char * s)"<Bar>echoh None<cr>
inorea strdup	strdup<c-o>:echoh HintHL<Bar>echo "char *strdup(const char * s)"<Bar>echoh None<cr>
inorea strerror_r	strerror_r<c-o>:echoh HintHL<Bar>echo "char *strerror_r(int errnum, char * buf, size_t buflen)"<Bar>echoh None<cr>
inorea strerror_r	strerror_r<c-o>:echoh HintHL<Bar>echo "int strerror_r(int errnum, char * buf, size_t buflen)"<Bar>echoh None<cr>
inorea strerror	strerror<c-o>:echoh HintHL<Bar>echo "char *strerror(int errnum)"<Bar>echoh None<cr>
inorea strfmon	strfmon<c-o>:echoh HintHL<Bar>echo "ssize_t strfmon(char * s, size_t max, const char * format, ...)"<Bar>echoh None<cr>
inorea strfry	strfry<c-o>:echoh HintHL<Bar>echo "char *strfry(char * string)"<Bar>echoh None<cr>
inorea strftime	strftime<c-o>:echoh HintHL<Bar>echo "size_t strftime(char * s, size_t max, const char * format, const struct tm * tm)"<Bar>echoh None<cr>
inorea stringprep_4i	stringprep_4i<c-o>:echoh HintHL<Bar>echo "int stringprep_4i(uint32_t * ucs4, size_t * len, size_t maxucs4len, Stringprep_profile_flags flags, const Stringprep_profile * profile)"<Bar>echoh None<cr>
inorea stringprep_4zi	stringprep_4zi<c-o>:echoh HintHL<Bar>echo "int stringprep_4zi(uint32_t * ucs4, size_t maxucs4len, Stringprep_profile_flags flags, const Stringprep_profile * profile)"<Bar>echoh None<cr>
inorea stringprep_check_version	stringprep_check_version<c-o>:echoh HintHL<Bar>echo "const char * stringprep_check_version(const char * req_version)"<Bar>echoh None<cr>
inorea stringprep_convert	stringprep_convert<c-o>:echoh HintHL<Bar>echo "char * stringprep_convert(const char * str, const char * to_codeset, const char * from_codeset)"<Bar>echoh None<cr>
inorea stringprep_locale_charset	stringprep_locale_charset<c-o>:echoh HintHL<Bar>echo "const char * stringprep_locale_charset( void)"<Bar>echoh None<cr>
inorea stringprep_locale_to_utf8	stringprep_locale_to_utf8<c-o>:echoh HintHL<Bar>echo "char * stringprep_locale_to_utf8(const char * str)"<Bar>echoh None<cr>
inorea stringprep_profile	stringprep_profile<c-o>:echoh HintHL<Bar>echo "int stringprep_profile(const char * in, char ** out, const char * profile, Stringprep_profile_flags flags)"<Bar>echoh None<cr>
inorea stringprep_strerror	stringprep_strerror<c-o>:echoh HintHL<Bar>echo "const char * stringprep_strerror(Stringprep_rc rc)"<Bar>echoh None<cr>
inorea stringprep	stringprep<c-o>:echoh HintHL<Bar>echo "int stringprep(char * in, size_t maxlen, Stringprep_profile_flags flags, const Stringprep_profile * profile)"<Bar>echoh None<cr>
inorea stringprep_ucs4_nfkc_normalize	stringprep_ucs4_nfkc_normalize<c-o>:echoh HintHL<Bar>echo "uint32_t * stringprep_ucs4_nfkc_normalize(uint32_t * str, ssize_t len)"<Bar>echoh None<cr>
inorea stringprep_ucs4_to_utf8	stringprep_ucs4_to_utf8<c-o>:echoh HintHL<Bar>echo "char * stringprep_ucs4_to_utf8(const uint32_t * str, ssize_t len, size_t * items_read, size_t * items_written)"<Bar>echoh None<cr>
inorea stringprep_unichar_to_utf8	stringprep_unichar_to_utf8<c-o>:echoh HintHL<Bar>echo "int stringprep_unichar_to_utf8(uint32_t c, char * outbuf)"<Bar>echoh None<cr>
inorea stringprep_utf8_nfkc_normalize	stringprep_utf8_nfkc_normalize<c-o>:echoh HintHL<Bar>echo "char * stringprep_utf8_nfkc_normalize(const char * str, ssize_t len)"<Bar>echoh None<cr>
inorea stringprep_utf8_to_locale	stringprep_utf8_to_locale<c-o>:echoh HintHL<Bar>echo "char * stringprep_utf8_to_locale(const char * str)"<Bar>echoh None<cr>
inorea stringprep_utf8_to_ucs4	stringprep_utf8_to_ucs4<c-o>:echoh HintHL<Bar>echo "uint32_t * stringprep_utf8_to_ucs4(const char * str, ssize_t len, size_t * items_written)"<Bar>echoh None<cr>
inorea stringprep_utf8_to_unichar	stringprep_utf8_to_unichar<c-o>:echoh HintHL<Bar>echo "uint32_t stringprep_utf8_to_unichar(const char * p)"<Bar>echoh None<cr>
inorea strlen	strlen<c-o>:echoh HintHL<Bar>echo "size_t strlen(const char * s)"<Bar>echoh None<cr>
inorea strncasecmp	strncasecmp<c-o>:echoh HintHL<Bar>echo "int strncasecmp(const char * s1, const char * s2, size_t n)"<Bar>echoh None<cr>
inorea strncat	strncat<c-o>:echoh HintHL<Bar>echo "char *strncat(char * dest, const char * src, size_t n)"<Bar>echoh None<cr>
inorea strncmp	strncmp<c-o>:echoh HintHL<Bar>echo "int strncmp(const char * s1, const char * s2, size_t n)"<Bar>echoh None<cr>
inorea strncpy	strncpy<c-o>:echoh HintHL<Bar>echo "char *strncpy(char * dest, const char * src, size_t n)"<Bar>echoh None<cr>
inorea strndupa	strndupa<c-o>:echoh HintHL<Bar>echo "char *strndupa(const char * s, size_t n)"<Bar>echoh None<cr>
inorea strndup	strndup<c-o>:echoh HintHL<Bar>echo "char *strndup(const char * s, size_t n)"<Bar>echoh None<cr>
inorea strnlen	strnlen<c-o>:echoh HintHL<Bar>echo "size_t strnlen(const char * s, size_t maxlen)"<Bar>echoh None<cr>
inorea strpbrk	strpbrk<c-o>:echoh HintHL<Bar>echo "char *strpbrk(const char * s, const char * accept)"<Bar>echoh None<cr>
inorea strptime	strptime<c-o>:echoh HintHL<Bar>echo "char *strptime(const char * s, const char * format, struct tm * tm)"<Bar>echoh None<cr>
inorea strrchr	strrchr<c-o>:echoh HintHL<Bar>echo "char *strrchr(const char * s, int c)"<Bar>echoh None<cr>
inorea strsep	strsep<c-o>:echoh HintHL<Bar>echo "char *strsep(char ** stringp, const char * delim)"<Bar>echoh None<cr>
inorea strsignal	strsignal<c-o>:echoh HintHL<Bar>echo "char *strsignal(int sig)"<Bar>echoh None<cr>
inorea strspn	strspn<c-o>:echoh HintHL<Bar>echo "size_t strspn(const char * s, const char * accept)"<Bar>echoh None<cr>
inorea strstr	strstr<c-o>:echoh HintHL<Bar>echo "char *strstr(const char * haystack, const char * needle)"<Bar>echoh None<cr>
inorea strtod	strtod<c-o>:echoh HintHL<Bar>echo "double strtod(const char * nptr, char ** endptr)"<Bar>echoh None<cr>
inorea strtof	strtof<c-o>:echoh HintHL<Bar>echo "float strtof(const char * nptr, char ** endptr)"<Bar>echoh None<cr>
inorea strtoimax	strtoimax<c-o>:echoh HintHL<Bar>echo "intmax_t strtoimax (const char * nptr, char ** endptr, int base)"<Bar>echoh None<cr>
inorea strtok_r	strtok_r<c-o>:echoh HintHL<Bar>echo "char *strtok_r(char * str, const char * delim, char ** saveptr)"<Bar>echoh None<cr>
inorea strtok	strtok<c-o>:echoh HintHL<Bar>echo "char *strtok(char * s, const char * delim)"<Bar>echoh None<cr>
inorea strtok	strtok<c-o>:echoh HintHL<Bar>echo "char *strtok(char * str, const char * delim)"<Bar>echoh None<cr>
inorea strtold	strtold<c-o>:echoh HintHL<Bar>echo "long double strtold(const char * nptr, char ** endptr)"<Bar>echoh None<cr>
inorea strtoll	strtoll<c-o>:echoh HintHL<Bar>echo "strtoll(const char * nptr, char ** endptr, int base)"<Bar>echoh None<cr>
inorea strtol	strtol<c-o>:echoh HintHL<Bar>echo "strtol(const char * nptr, char ** endptr, int base)"<Bar>echoh None<cr>
inorea strtoull	strtoull<c-o>:echoh HintHL<Bar>echo "strtoull(const char * nptr, char ** endptr, int base)"<Bar>echoh None<cr>
inorea strtoul	strtoul<c-o>:echoh HintHL<Bar>echo "strtoul(const char * nptr, char ** endptr, int base)"<Bar>echoh None<cr>
inorea strverscmp	strverscmp<c-o>:echoh HintHL<Bar>echo "int strverscmp(const char * s1, const char * s2)"<Bar>echoh None<cr>
inorea strxfrm	strxfrm<c-o>:echoh HintHL<Bar>echo "size_t strxfrm(char * dest, const char * src, size_t n)"<Bar>echoh None<cr>
inorea subpad	subpad<c-o>:echoh HintHL<Bar>echo "WINDOW *subpad(WINDOW *orig, int nlines, int ncols, int begin_y, int begin_x)"<Bar>echoh None<cr>
inorea subwin	subwin<c-o>:echoh HintHL<Bar>echo "WINDOW *subwin(WINDOW *orig, int nlines, int ncols, int begin_y, int begin_x)"<Bar>echoh None<cr>
inorea swab	swab<c-o>:echoh HintHL<Bar>echo "void swab(const void * from, void * to, ssize_t n)"<Bar>echoh None<cr>
inorea swapcontext	swapcontext<c-o>:echoh HintHL<Bar>echo "int swapcontext (ucontext_t * oucp, ucontext_t * ucp)"<Bar>echoh None<cr>
inorea swprintf	swprintf<c-o>:echoh HintHL<Bar>echo "int swprintf(wchar_t * wcs, size_t maxlen, const wchar_t * format, ...)"<Bar>echoh None<cr>
inorea syncok	syncok<c-o>:echoh HintHL<Bar>echo "int syncok(WINDOW *win, bool bf)"<Bar>echoh None<cr>
inorea sysconf	sysconf<c-o>:echoh HintHL<Bar>echo "long sysconf(int name)"<Bar>echoh None<cr>
inorea syslog	syslog<c-o>:echoh HintHL<Bar>echo "void syslog(int priority, const char * format, ...)"<Bar>echoh None<cr>
inorea system	system<c-o>:echoh HintHL<Bar>echo "int system(const char * command)"<Bar>echoh None<cr>
inorea tanf	tanf<c-o>:echoh HintHL<Bar>echo "float tanf(float x)"<Bar>echoh None<cr>
inorea tanhf	tanhf<c-o>:echoh HintHL<Bar>echo "float tanhf(float x)"<Bar>echoh None<cr>
inorea tanhl	tanhl<c-o>:echoh HintHL<Bar>echo "long double tanhl(long double x)"<Bar>echoh None<cr>
inorea tanh	tanh<c-o>:echoh HintHL<Bar>echo "double tanh(double x)"<Bar>echoh None<cr>
inorea tanl	tanl<c-o>:echoh HintHL<Bar>echo "long double tanl(long double x)"<Bar>echoh None<cr>
inorea tan	tan<c-o>:echoh HintHL<Bar>echo "double tan(double x)"<Bar>echoh None<cr>
inorea tcdrain	tcdrain<c-o>:echoh HintHL<Bar>echo "int tcdrain(int fd)"<Bar>echoh None<cr>
inorea tcflow	tcflow<c-o>:echoh HintHL<Bar>echo "int tcflow(int fd, int action)"<Bar>echoh None<cr>
inorea tcflush	tcflush<c-o>:echoh HintHL<Bar>echo "int tcflush(int fd, int queue_selector)"<Bar>echoh None<cr>
inorea tcgetattr	tcgetattr<c-o>:echoh HintHL<Bar>echo "int tcgetattr(int fd, struct termios * termios_p)"<Bar>echoh None<cr>
inorea tcgetpgrp	tcgetpgrp<c-o>:echoh HintHL<Bar>echo "pid_t tcgetpgrp(int fd)"<Bar>echoh None<cr>
inorea tcgetsid	tcgetsid<c-o>:echoh HintHL<Bar>echo "pid_t tcgetsid(int fd)"<Bar>echoh None<cr>
inorea tcsendbreak	tcsendbreak<c-o>:echoh HintHL<Bar>echo "int tcsendbreak(int fd, int duration)"<Bar>echoh None<cr>
inorea tcsetattr	tcsetattr<c-o>:echoh HintHL<Bar>echo "int tcsetattr(int fd, int optional_actions, const struct termios * termios_p)"<Bar>echoh None<cr>
inorea tcsetpgrp	tcsetpgrp<c-o>:echoh HintHL<Bar>echo "int tcsetpgrp(int fd, pid_t pgrp)"<Bar>echoh None<cr>
inorea tdelete	tdelete<c-o>:echoh HintHL<Bar>echo "void *tdelete(const void * key, void ** rootp, int(* compar)(const void *, const void *))"<Bar>echoh None<cr>
inorea tdestroy	tdestroy<c-o>:echoh HintHL<Bar>echo "void tdestroy (void * root, void (* free_node)(void * nodep))"<Bar>echoh None<cr>
inorea telldir	telldir<c-o>:echoh HintHL<Bar>echo "off_t telldir(DIR * dir)"<Bar>echoh None<cr>
inorea tempnam	tempnam<c-o>:echoh HintHL<Bar>echo "char *tempnam(const char * dir, const char * pfx)"<Bar>echoh None<cr>
inorea term_attrs	term_attrs<c-o>:echoh HintHL<Bar>echo "attr_t term_attrs(void)"<Bar>echoh None<cr>
inorea termattrs	termattrs<c-o>:echoh HintHL<Bar>echo "chtype termattrs(void)"<Bar>echoh None<cr>
inorea termname	termname<c-o>:echoh HintHL<Bar>echo "char *termname(void)"<Bar>echoh None<cr>
inorea tfind	tfind<c-o>:echoh HintHL<Bar>echo "void *tfind(const void * key, const void ** rootp, int(* compar)(const void *, const void *))"<Bar>echoh None<cr>
inorea tgammaf	tgammaf<c-o>:echoh HintHL<Bar>echo "float tgammaf(float x)"<Bar>echoh None<cr>
inorea tgammal	tgammal<c-o>:echoh HintHL<Bar>echo "long double tgammal(long double x)"<Bar>echoh None<cr>
inorea tgamma	tgamma<c-o>:echoh HintHL<Bar>echo "double tgamma(double x)"<Bar>echoh None<cr>
inorea tgetent	tgetent<c-o>:echoh HintHL<Bar>echo "int tgetent(char *bp, const char *name)"<Bar>echoh None<cr>
inorea tgetflag	tgetflag<c-o>:echoh HintHL<Bar>echo "int tgetflag(char *id)"<Bar>echoh None<cr>
inorea tgetnum	tgetnum<c-o>:echoh HintHL<Bar>echo "int tgetnum(char *id)"<Bar>echoh None<cr>
inorea tgetstr	tgetstr<c-o>:echoh HintHL<Bar>echo "char *tgetstr(char *id, char **area)"<Bar>echoh None<cr>
inorea tgoto	tgoto<c-o>:echoh HintHL<Bar>echo "char *tgoto(const char *cap, int col, int row)"<Bar>echoh None<cr>
inorea TIFFCheckpointDirectory	TIFFCheckpointDirectory<c-o>:echoh HintHL<Bar>echo "int TIFFCheckpointDirectory(TIFF * tif)"<Bar>echoh None<cr>
inorea TIFFCheckTile	TIFFCheckTile<c-o>:echoh HintHL<Bar>echo "int TIFFCheckTile(TIFF * tif, uint32 x, uint32 y, uint32 z, tsample_t sample)"<Bar>echoh None<cr>
inorea TIFFCIELabToRGBInit	TIFFCIELabToRGBInit<c-o>:echoh HintHL<Bar>echo "int TIFFCIELabToRGBInit(TIFFCIELabToRGB * cielab, TIFFDisplay * display, float * refWhite)"<Bar>echoh None<cr>
inorea TIFFCIELabToXYZ	TIFFCIELabToXYZ<c-o>:echoh HintHL<Bar>echo "void TIFFCIELabToXYZ(TIFFCIELabToRGB * cielab, uint32 L, int32 a, int32 b, float * X, float * Y, float * Z)"<Bar>echoh None<cr>
inorea TIFFClientOpen	TIFFClientOpen<c-o>:echoh HintHL<Bar>echo "TIFF* TIFFClientOpen(const char * filename, const char * mode, thandle_t clientdata, TIFFReadWriteProc readproc, TIFFReadWriteProc writeproc, TIFFSeekProc seekproc, TIFFCloseProc closeproc, TIFFSizeProc sizeproc, TIFFMapFileProc mapproc, TIFFUnmapFileProc unmapproc)"<Bar>echoh None<cr>
inorea TIFFClose	TIFFClose<c-o>:echoh HintHL<Bar>echo "void TIFFClose(TIFF * tif)"<Bar>echoh None<cr>
inorea TIFFComputeStrip	TIFFComputeStrip<c-o>:echoh HintHL<Bar>echo "tstrip_t TIFFComputeStrip(TIFF * tif, uint32 row, tsample_t sample)"<Bar>echoh None<cr>
inorea TIFFComputeTile	TIFFComputeTile<c-o>:echoh HintHL<Bar>echo "ttile_t TIFFComputeTile(TIFF * tif, uint32 x, uint32 y, uint32 z, tsample_t sample)"<Bar>echoh None<cr>
inorea TIFFCurrentDirectory	TIFFCurrentDirectory<c-o>:echoh HintHL<Bar>echo "tdir_t TIFFCurrentDirectory(TIFF* tif)"<Bar>echoh None<cr>
inorea TIFFCurrentRow	TIFFCurrentRow<c-o>:echoh HintHL<Bar>echo "uint32 TIFFCurrentRow(TIFF* tif)"<Bar>echoh None<cr>
inorea TIFFCurrentStrip	TIFFCurrentStrip<c-o>:echoh HintHL<Bar>echo "tstrip_t TIFFCurrentStrip(TIFF* tif)"<Bar>echoh None<cr>
inorea TIFFCurrentTile	TIFFCurrentTile<c-o>:echoh HintHL<Bar>echo "ttile_t TIFFCurrentTile(TIFF* tif)"<Bar>echoh None<cr>
inorea TIFFDataWidth	TIFFDataWidth<c-o>:echoh HintHL<Bar>echo "int TIFFDataWidth(TIFFDataType type)"<Bar>echoh None<cr>
inorea TIFFDefaultStripSize	TIFFDefaultStripSize<c-o>:echoh HintHL<Bar>echo "uint32 TIFFDefaultStripSize(TIFF * tif, uint32 estimate)"<Bar>echoh None<cr>
inorea TIFFDefaultTileSize	TIFFDefaultTileSize<c-o>:echoh HintHL<Bar>echo "void TIFFDefaultTileSize(TIFF * tif, uint32 * tw, uint32 * th)"<Bar>echoh None<cr>
inorea TIFFError	TIFFError<c-o>:echoh HintHL<Bar>echo "void TIFFError(const char * module, const char * fmt, ...)"<Bar>echoh None<cr>
inorea TIFFFdOpen	TIFFFdOpen<c-o>:echoh HintHL<Bar>echo "TIFF* TIFFFdOpen(const int fd, const char * filename, const char * mode)"<Bar>echoh None<cr>
inorea TIFFFileName	TIFFFileName<c-o>:echoh HintHL<Bar>echo "char* TIFFFileName(TIFF* tif)"<Bar>echoh None<cr>
inorea TIFFFileno	TIFFFileno<c-o>:echoh HintHL<Bar>echo "int TIFFFileno(TIFF* tif)"<Bar>echoh None<cr>
inorea TIFFFindCODEC	TIFFFindCODEC<c-o>:echoh HintHL<Bar>echo "const TIFFCodec* TIFFFindCODEC(uint16 scheme)"<Bar>echoh None<cr>
inorea TIFFFlushData	TIFFFlushData<c-o>:echoh HintHL<Bar>echo "int TIFFFlushData(TIFF * tif)"<Bar>echoh None<cr>
inorea TIFFFlush	TIFFFlush<c-o>:echoh HintHL<Bar>echo "int TIFFFlush(TIFF * tif)"<Bar>echoh None<cr>
inorea _TIFFfree	_TIFFfree<c-o>:echoh HintHL<Bar>echo "void _TIFFfree(tdata_t buffer)"<Bar>echoh None<cr>
inorea TIFFGetBitRevTable	TIFFGetBitRevTable<c-o>:echoh HintHL<Bar>echo "const unsigned char* TIFFGetBitRevTable(int reversed)"<Bar>echoh None<cr>
inorea TIFFGetFieldDefaulted	TIFFGetFieldDefaulted<c-o>:echoh HintHL<Bar>echo "int TIFFGetFieldDefaulted(TIFF * tif, ttag_t tag, ...)"<Bar>echoh None<cr>
inorea TIFFGetField	TIFFGetField<c-o>:echoh HintHL<Bar>echo "int TIFFGetField(TIFF * tif, ttag_t tag, ...)"<Bar>echoh None<cr>
inorea TIFFGetMode	TIFFGetMode<c-o>:echoh HintHL<Bar>echo "int TIFFGetMode(TIFF* tif)"<Bar>echoh None<cr>
inorea TIFFGetVersion	TIFFGetVersion<c-o>:echoh HintHL<Bar>echo "const char* TIFFGetVersion(void)"<Bar>echoh None<cr>
inorea TIFFIsByteSwapped	TIFFIsByteSwapped<c-o>:echoh HintHL<Bar>echo "int TIFFIsByteSwapped(TIFF* tif)"<Bar>echoh None<cr>
inorea TIFFIsCODECConfigured	TIFFIsCODECConfigured<c-o>:echoh HintHL<Bar>echo "int TIFFIsCODECConfigured(uint16 scheme)"<Bar>echoh None<cr>
inorea TIFFIsMSB2LSB	TIFFIsMSB2LSB<c-o>:echoh HintHL<Bar>echo "int TIFFIsMSB2LSB(TIFF* tif)"<Bar>echoh None<cr>
inorea TIFFIsTiled	TIFFIsTiled<c-o>:echoh HintHL<Bar>echo "int TIFFIsTiled(TIFF* tif)"<Bar>echoh None<cr>
inorea TIFFIsUpSampled	TIFFIsUpSampled<c-o>:echoh HintHL<Bar>echo "int TIFFIsUpSampled(TIFF* tif)"<Bar>echoh None<cr>
inorea TIFFLastDirectory	TIFFLastDirectory<c-o>:echoh HintHL<Bar>echo "int TIFFLastDirectory(TIFF* tif)"<Bar>echoh None<cr>
inorea _TIFFmalloc	_TIFFmalloc<c-o>:echoh HintHL<Bar>echo "tdata_t _TIFFmalloc(tsize_t size)"<Bar>echoh None<cr>
inorea _TIFFmemcmp	_TIFFmemcmp<c-o>:echoh HintHL<Bar>echo "int _TIFFmemcmp(const tdata_t s1, const tdata_t s2, tsize_t n)"<Bar>echoh None<cr>
inorea _TIFFmemcpy	_TIFFmemcpy<c-o>:echoh HintHL<Bar>echo "void _TIFFmemcpy(tdata_t dest, const tdata_t src, tsize_t n)"<Bar>echoh None<cr>
inorea _TIFFmemset	_TIFFmemset<c-o>:echoh HintHL<Bar>echo "void _TIFFmemset(tdata_t s, int c, tsize_t n)"<Bar>echoh None<cr>
inorea TIFFNumberOfStrips	TIFFNumberOfStrips<c-o>:echoh HintHL<Bar>echo "tstrip_t TIFFNumberOfStrips(TIFF * tif)"<Bar>echoh None<cr>
inorea TIFFNumberOfTiles	TIFFNumberOfTiles<c-o>:echoh HintHL<Bar>echo "ttile_t TIFFNumberOfTiles(TIFF * tif)"<Bar>echoh None<cr>
inorea TIFFOpen	TIFFOpen<c-o>:echoh HintHL<Bar>echo "TIFF* TIFFOpen(const char * filename, const char * mode)"<Bar>echoh None<cr>
inorea TIFFPrintDirectory	TIFFPrintDirectory<c-o>:echoh HintHL<Bar>echo "void TIFFPrintDirectory(TIFF * tif, FILE * fd, long flags)"<Bar>echoh None<cr>
inorea TIFFRasterScanlineSize	TIFFRasterScanlineSize<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFRasterScanlineSize(TIFF * tif)"<Bar>echoh None<cr>
inorea TIFFRawStripSize	TIFFRawStripSize<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFRawStripSize(TIFF * tif, tstrip_t strip)"<Bar>echoh None<cr>
inorea TIFFReadBufferSetup	TIFFReadBufferSetup<c-o>:echoh HintHL<Bar>echo "int TIFFReadBufferSetup(TIFF * tif, tdata_t buffer, tsize_t size)"<Bar>echoh None<cr>
inorea TIFFReadDirectory	TIFFReadDirectory<c-o>:echoh HintHL<Bar>echo "int TIFFReadDirectory(TIFF * tif)"<Bar>echoh None<cr>
inorea TIFFReadEncodedStrip	TIFFReadEncodedStrip<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFReadEncodedStrip(TIFF * tif, tstrip_t strip, tdata_t buf, tsize_t size)"<Bar>echoh None<cr>
inorea TIFFReadEncodedTile	TIFFReadEncodedTile<c-o>:echoh HintHL<Bar>echo "int TIFFReadEncodedTile(TIFF * tif, u_long tile, u_char * buf, u_long size)"<Bar>echoh None<cr>
inorea TIFFReadRawStrip	TIFFReadRawStrip<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFReadRawStrip(TIFF * tif, tstrip_t strip, tdata_t buf, tsize_t size)"<Bar>echoh None<cr>
inorea TIFFReadRawTile	TIFFReadRawTile<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFReadRawTile(TIFF * tif, ttile_t tile, tdata_t buf, tsize_t size)"<Bar>echoh None<cr>
inorea TIFFReadRGBAImageOriented	TIFFReadRGBAImageOriented<c-o>:echoh HintHL<Bar>echo "int TIFFReadRGBAImageOriented(TIFF * tif, u_long width, u_long height, u_long * raster, int orientation, int stopOnError)"<Bar>echoh None<cr>
inorea TIFFReadRGBAImage	TIFFReadRGBAImage<c-o>:echoh HintHL<Bar>echo "int TIFFReadRGBAImage(TIFF * tif, u_long width, u_long height, u_long * raster, int stopOnError)"<Bar>echoh None<cr>
inorea TIFFReadRGBAStrip	TIFFReadRGBAStrip<c-o>:echoh HintHL<Bar>echo "int TIFFReadRGBAStrip(TIFF * tif, uint32 row, uint32 * raster)"<Bar>echoh None<cr>
inorea TIFFReadRGBATile	TIFFReadRGBATile<c-o>:echoh HintHL<Bar>echo "int TIFFReadRGBATile(TIFF * tif, uint32 x, uint32 y, uint32 * raster)"<Bar>echoh None<cr>
inorea TIFFReadScanline	TIFFReadScanline<c-o>:echoh HintHL<Bar>echo "int TIFFReadScanline(TIFF * tif, tdata_t buf, uint32 row, tsample_t sample)"<Bar>echoh None<cr>
inorea TIFFReadTile	TIFFReadTile<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFReadTile(TIFF * tif, tdata_t buf, uint32 x, uint32 y, uint32 z, tsample_t sample)"<Bar>echoh None<cr>
inorea _TIFFrealloc	_TIFFrealloc<c-o>:echoh HintHL<Bar>echo "tdata_t _TIFFrealloc(tdata_t buffer, tsize_t size)"<Bar>echoh None<cr>
inorea TIFFRegisterCODEC	TIFFRegisterCODEC<c-o>:echoh HintHL<Bar>echo "TIFFCodec* TIFFRegisterCODEC(uint16 scheme, const char * method, TIFFInitMethod init)"<Bar>echoh None<cr>
inorea TIFFReverseBits	TIFFReverseBits<c-o>:echoh HintHL<Bar>echo "void TIFFReverseBits(u_char * data, unsigned long nbytes)"<Bar>echoh None<cr>
inorea TIFFRewriteDirectory	TIFFRewriteDirectory<c-o>:echoh HintHL<Bar>echo "int TIFFRewriteDirectory(TIFF * tif)"<Bar>echoh None<cr>
inorea TIFFRGBAImageBegin	TIFFRGBAImageBegin<c-o>:echoh HintHL<Bar>echo "int TIFFRGBAImageBegin(TIFFRGBAImage * img, TIFF* tif, int stopOnError, char emsg[1024])"<Bar>echoh None<cr>
inorea TIFFRGBAImageEnd	TIFFRGBAImageEnd<c-o>:echoh HintHL<Bar>echo "void TIFFRGBAImageEnd(TIFFRGBAImage * img)"<Bar>echoh None<cr>
inorea TIFFRGBAImageGet	TIFFRGBAImageGet<c-o>:echoh HintHL<Bar>echo "int TIFFRGBAImageGet(TIFFRGBAImage * img, uint32* raster, uint32 width, uint32 height)"<Bar>echoh None<cr>
inorea TIFFRGBAImageOK	TIFFRGBAImageOK<c-o>:echoh HintHL<Bar>echo "int TIFFRGBAImageOK(TIFF * tif, char emsg[1024])"<Bar>echoh None<cr>
inorea TIFFScanlineSize	TIFFScanlineSize<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFScanlineSize(TIFF * tif)"<Bar>echoh None<cr>
inorea TIFFSetDirectory	TIFFSetDirectory<c-o>:echoh HintHL<Bar>echo "int TIFFSetDirectory(TIFF * tif, tdir_t dirnum)"<Bar>echoh None<cr>
inorea TIFFSetErrorHandler	TIFFSetErrorHandler<c-o>:echoh HintHL<Bar>echo "TIFFErrorHandler TIFFSetErrorHandler(TIFFErrorHandler handler)"<Bar>echoh None<cr>
inorea TIFFSetField	TIFFSetField<c-o>:echoh HintHL<Bar>echo "int TIFFSetField(TIFF * tif, ttag_t tag, ...)"<Bar>echoh None<cr>
inorea TIFFSetSubDirectory	TIFFSetSubDirectory<c-o>:echoh HintHL<Bar>echo "int TIFFSetSubDirectory(TIFF * tif, uint32 diroff)"<Bar>echoh None<cr>
inorea TIFFSetWarningHandler	TIFFSetWarningHandler<c-o>:echoh HintHL<Bar>echo "TIFFWarningHandler TIFFSetWarningHandler(TIFFWarningHandler handler)"<Bar>echoh None<cr>
inorea TIFFStripSize	TIFFStripSize<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFStripSize(TIFF * tif)"<Bar>echoh None<cr>
inorea TIFFSwabArrayOfLong	TIFFSwabArrayOfLong<c-o>:echoh HintHL<Bar>echo "void TIFFSwabArrayOfLong(uint32 * data, unsigned long nlongs)"<Bar>echoh None<cr>
inorea TIFFSwabArrayOfShort	TIFFSwabArrayOfShort<c-o>:echoh HintHL<Bar>echo "void TIFFSwabArrayOfShort(uint16 * data, unsigned long nshorts)"<Bar>echoh None<cr>
inorea TIFFSwabLong	TIFFSwabLong<c-o>:echoh HintHL<Bar>echo "void TIFFSwabLong(uint32 * data)"<Bar>echoh None<cr>
inorea TIFFSwabShort	TIFFSwabShort<c-o>:echoh HintHL<Bar>echo "void TIFFSwabShort(uint16 * data)"<Bar>echoh None<cr>
inorea TIFFTileRowSize	TIFFTileRowSize<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFTileRowSize(TIFF * tif)"<Bar>echoh None<cr>
inorea TIFFTileSize	TIFFTileSize<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFTileSize(TIFF * tif)"<Bar>echoh None<cr>
inorea TIFFUnRegisterCODEC	TIFFUnRegisterCODEC<c-o>:echoh HintHL<Bar>echo "void TIFFUnRegisterCODEC(TIFFCodec * codec)"<Bar>echoh None<cr>
inorea TIFFVGetFieldDefaulted	TIFFVGetFieldDefaulted<c-o>:echoh HintHL<Bar>echo "int TIFFVGetFieldDefaulted(TIFF * tif, ttag_t tag, va_list ap)"<Bar>echoh None<cr>
inorea TIFFVGetField	TIFFVGetField<c-o>:echoh HintHL<Bar>echo "int TIFFVGetField(TIFF * tif, ttag_t tag, va_list ap)"<Bar>echoh None<cr>
inorea TIFFVSetField	TIFFVSetField<c-o>:echoh HintHL<Bar>echo "int TIFFVSetField(TIFF * tif, ttag_t tag, va_list ap)"<Bar>echoh None<cr>
inorea TIFFVStripSize	TIFFVStripSize<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFVStripSize(TIFF * tif, uint32 nrows)"<Bar>echoh None<cr>
inorea TIFFVTileSize	TIFFVTileSize<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFVTileSize(TIFF * tif, uint32 nrows)"<Bar>echoh None<cr>
inorea TIFFWarning	TIFFWarning<c-o>:echoh HintHL<Bar>echo "void TIFFWarning(const char * module, const char * fmt, ...)"<Bar>echoh None<cr>
inorea TIFFWriteBufferSetup	TIFFWriteBufferSetup<c-o>:echoh HintHL<Bar>echo "int TIFFWriteBufferSetup(TIFF * tif, tdata_t buffer, tsize_t size)"<Bar>echoh None<cr>
inorea TIFFWriteDirectory	TIFFWriteDirectory<c-o>:echoh HintHL<Bar>echo "int TIFFWriteDirectory(TIFF * tif)"<Bar>echoh None<cr>
inorea TIFFWriteEncodedStrip	TIFFWriteEncodedStrip<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFWriteEncodedStrip(TIFF * tif, tstrip_t strip, tdata_t buf, tsize_t size)"<Bar>echoh None<cr>
inorea TIFFWriteEncodedTile	TIFFWriteEncodedTile<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFWriteEncodedTile(TIFF * tif, ttile_t tile, tdata_t buf, tsize_t size)"<Bar>echoh None<cr>
inorea TIFFWriteRawStrip	TIFFWriteRawStrip<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFWriteRawStrip(TIFF * tif, tstrip_t strip, tdata_t buf, tsize_t size)"<Bar>echoh None<cr>
inorea TIFFWriteRawTile	TIFFWriteRawTile<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFWriteRawTile(TIFF * tif, ttile_t tile, tdata_t buf, tsize_t size)"<Bar>echoh None<cr>
inorea TIFFWriteScanline	TIFFWriteScanline<c-o>:echoh HintHL<Bar>echo "int TIFFWriteScanline(TIFF * tif, tdata_t buf, uint32 row, tsample_t sample)"<Bar>echoh None<cr>
inorea TIFFWriteTile	TIFFWriteTile<c-o>:echoh HintHL<Bar>echo "tsize_t TIFFWriteTile(TIFF * tif, tdata_t buf, uint32 x, uint32 y, uint32 z, tsample_t sample)"<Bar>echoh None<cr>
inorea TIFFXYZToRGB	TIFFXYZToRGB<c-o>:echoh HintHL<Bar>echo "void TIFFXYZToRGB(TIFFCIELabToRGB * cielab, float X, float Y, float Z, uint32 * R, uint32 * G, uint32 * B)"<Bar>echoh None<cr>
inorea TIFFYCbCrToRGBInit	TIFFYCbCrToRGBInit<c-o>:echoh HintHL<Bar>echo "int TIFFYCbCrToRGBInit(TIFFYCbCrToRGB * ycbcr, float * luma, float *refBlackWhite)"<Bar>echoh None<cr>
inorea TIFFYCbCrtoRGB	TIFFYCbCrtoRGB<c-o>:echoh HintHL<Bar>echo "void TIFFYCbCrtoRGB(TIFFYCbCrToRGB * ycbcr, uint32 Y, int32 Cb, int32 Cr, uint32 * R, uint32 * G, uint32 * B)"<Bar>echoh None<cr>
inorea tigetflag	tigetflag<c-o>:echoh HintHL<Bar>echo "int tigetflag(char *capname)"<Bar>echoh None<cr>
inorea tigetnum	tigetnum<c-o>:echoh HintHL<Bar>echo "int tigetnum(char *capname)"<Bar>echoh None<cr>
inorea tigetstr	tigetstr<c-o>:echoh HintHL<Bar>echo "char *tigetstr(char *capname)"<Bar>echoh None<cr>
inorea timegm	timegm<c-o>:echoh HintHL<Bar>echo "time_t timegm (struct tm * tm)"<Bar>echoh None<cr>
inorea timelocal	timelocal<c-o>:echoh HintHL<Bar>echo "time_t timelocal (struct tm * tm)"<Bar>echoh None<cr>
inorea timeout	timeout<c-o>:echoh HintHL<Bar>echo "void timeout(int delay)"<Bar>echoh None<cr>
inorea tld_check_4	tld_check_4<c-o>:echoh HintHL<Bar>echo "int tld_check_4(const uint32_t * in, size_t inlen, size_t * errpos, const Tld_table ** overrides)"<Bar>echoh None<cr>
inorea tld_check_4t	tld_check_4t<c-o>:echoh HintHL<Bar>echo "int tld_check_4t(const uint32_t * in, size_t inlen, size_t * errpos, const Tld_table * tld)"<Bar>echoh None<cr>
inorea tld_check_4tz	tld_check_4tz<c-o>:echoh HintHL<Bar>echo "int tld_check_4tz(const uint32_t * in, size_t * errpos, const Tld_table * tld)"<Bar>echoh None<cr>
inorea tld_check_4z	tld_check_4z<c-o>:echoh HintHL<Bar>echo "int tld_check_4z(const uint32_t * in, size_t * errpos, const Tld_table ** overrides)"<Bar>echoh None<cr>
inorea tld_check_8z	tld_check_8z<c-o>:echoh HintHL<Bar>echo "int tld_check_8z(const char * in, size_t * errpos, const Tld_table ** overrides)"<Bar>echoh None<cr>
inorea tld_check_lz	tld_check_lz<c-o>:echoh HintHL<Bar>echo "int tld_check_lz(const char * in, size_t * errpos, const Tld_table ** overrides)"<Bar>echoh None<cr>
inorea tld_default_table	tld_default_table<c-o>:echoh HintHL<Bar>echo "const Tld_table * tld_default_table(const char * tld, const Tld_table ** overrides)"<Bar>echoh None<cr>
inorea tld_get_4	tld_get_4<c-o>:echoh HintHL<Bar>echo "int tld_get_4(const uint32_t * in, size_t inlen, char ** out)"<Bar>echoh None<cr>
inorea tld_get_4z	tld_get_4z<c-o>:echoh HintHL<Bar>echo "int tld_get_4z(const uint32_t * in, char ** out)"<Bar>echoh None<cr>
inorea tld_get_table	tld_get_table<c-o>:echoh HintHL<Bar>echo "const Tld_table * tld_get_table(const char * tld, const Tld_table ** tables)"<Bar>echoh None<cr>
inorea tld_get_z	tld_get_z<c-o>:echoh HintHL<Bar>echo "int tld_get_z(const char * in, char ** out)"<Bar>echoh None<cr>
inorea tld_strerror	tld_strerror<c-o>:echoh HintHL<Bar>echo "const char * tld_strerror(Tld_rc rc)"<Bar>echoh None<cr>
inorea tmpfile	tmpfile<c-o>:echoh HintHL<Bar>echo "FILE *tmpfile (void)"<Bar>echoh None<cr>
inorea tmpnam	tmpnam<c-o>:echoh HintHL<Bar>echo "char *tmpnam(char * s)"<Bar>echoh None<cr>
inorea toascii	toascii<c-o>:echoh HintHL<Bar>echo "int toascii(int c)"<Bar>echoh None<cr>
inorea toff_t	toff_t<c-o>:echoh HintHL<Bar>echo "typedef toff_t (*TIFFSeekProc)(thandle_t, toff_t, int)"<Bar>echoh None<cr>
inorea toff_t	toff_t<c-o>:echoh HintHL<Bar>echo "typedef toff_t (*TIFFSizeProc)(thandle_t)"<Bar>echoh None<cr>
inorea tolower	tolower<c-o>:echoh HintHL<Bar>echo "int tolower(int c)"<Bar>echoh None<cr>
inorea top_panel	top_panel<c-o>:echoh HintHL<Bar>echo "int top_panel(PANEL *pan)"<Bar>echoh None<cr>
inorea top_row	top_row<c-o>:echoh HintHL<Bar>echo "int top_row(const MENU *menu)"<Bar>echoh None<cr>
inorea to	to<c-o>:echoh HintHL<Bar>echo "0 to (ntids - 1)"<Bar>echoh None<cr>
inorea touchline	touchline<c-o>:echoh HintHL<Bar>echo "int touchline(WINDOW *win, int start, int count)"<Bar>echoh None<cr>
inorea touchwin	touchwin<c-o>:echoh HintHL<Bar>echo "int touchwin(WINDOW *win)"<Bar>echoh None<cr>
inorea toupper	toupper<c-o>:echoh HintHL<Bar>echo "int toupper(int c)"<Bar>echoh None<cr>
inorea towctrans	towctrans<c-o>:echoh HintHL<Bar>echo "wint_t towctrans(wint_t wc, wctrans_t desc)"<Bar>echoh None<cr>
inorea towlower	towlower<c-o>:echoh HintHL<Bar>echo "wint_t towlower(wint_t wc)"<Bar>echoh None<cr>
inorea towupper	towupper<c-o>:echoh HintHL<Bar>echo "wint_t towupper(wint_t wc)"<Bar>echoh None<cr>
inorea tparm	tparm<c-o>:echoh HintHL<Bar>echo "char *tparm(char *str, ...)"<Bar>echoh None<cr>
inorea tputs	tputs<c-o>:echoh HintHL<Bar>echo "int tputs(const char *str, int affcnt, int (*putc)(int))"<Bar>echoh None<cr>
inorea _traceattr2	_traceattr2<c-o>:echoh HintHL<Bar>echo "char *_traceattr2(int buffer, chtype ch)"<Bar>echoh None<cr>
inorea _traceattr	_traceattr<c-o>:echoh HintHL<Bar>echo "char *_traceattr(attr_t attr)"<Bar>echoh None<cr>
inorea _tracechar	_tracechar<c-o>:echoh HintHL<Bar>echo "char *_tracechar(const unsigned char ch)"<Bar>echoh None<cr>
inorea _tracechtype2	_tracechtype2<c-o>:echoh HintHL<Bar>echo "char *_tracechtype2(int buffer, chtype ch)"<Bar>echoh None<cr>
inorea _tracechtype	_tracechtype<c-o>:echoh HintHL<Bar>echo "char *_tracechtype(chtype ch)"<Bar>echoh None<cr>
inorea _tracedump	_tracedump<c-o>:echoh HintHL<Bar>echo "void _tracedump(const char *label, WINDOW *win)"<Bar>echoh None<cr>
inorea _tracef	_tracef<c-o>:echoh HintHL<Bar>echo "void _tracef(const char *format, ...)"<Bar>echoh None<cr>
inorea _tracemouse	_tracemouse<c-o>:echoh HintHL<Bar>echo "char *_tracemouse(const MEVENT *event)"<Bar>echoh None<cr>
inorea trace	trace<c-o>:echoh HintHL<Bar>echo "void trace(const unsigned int param)"<Bar>echoh None<cr>
inorea truncf	truncf<c-o>:echoh HintHL<Bar>echo "float truncf(float x)"<Bar>echoh None<cr>
inorea truncl	truncl<c-o>:echoh HintHL<Bar>echo "long double truncl(long double x)"<Bar>echoh None<cr>
inorea trunc	trunc<c-o>:echoh HintHL<Bar>echo "double trunc(double x)"<Bar>echoh None<cr>
inorea tsearch	tsearch<c-o>:echoh HintHL<Bar>echo "void *tsearch(const void * key, void ** rootp, int(* compar)(const void *, const void *))"<Bar>echoh None<cr>
inorea tsize_t	tsize_t<c-o>:echoh HintHL<Bar>echo "typedef tsize_t (*TIFFReadWriteProc)(thandle_t, tdata_t, tsize_t)"<Bar>echoh None<cr>
inorea ttyname_r	ttyname_r<c-o>:echoh HintHL<Bar>echo "int ttyname_r(int fd, char * buf, size_t buflen)"<Bar>echoh None<cr>
inorea ttyname	ttyname<c-o>:echoh HintHL<Bar>echo "char *ttyname(int fd)"<Bar>echoh None<cr>
inorea ttyslot	ttyslot<c-o>:echoh HintHL<Bar>echo "int ttyslot(void)"<Bar>echoh None<cr>
inorea twalk	twalk<c-o>:echoh HintHL<Bar>echo "void twalk(const void * root, void(* action)(const void * nodep, const VISIT which, const int depth))"<Bar>echoh None<cr>
inorea typeahead	typeahead<c-o>:echoh HintHL<Bar>echo "int typeahead(int fd)"<Bar>echoh None<cr>
inorea typedefintne_ssl_verify_fn	typedefintne_ssl_verify_fn<c-o>:echoh HintHL<Bar>echo "typedefintne_ssl_verify_fn(void*userdata, intfailures, constne_ssl_certificate*cert)"<Bar>echoh None<cr>
inorea typedefint	typedefint<c-o>:echoh HintHL<Bar>echo "typedefint(*ne_request_auth)(void*userdata, constchar*realm, intattempt, char*username, char*password)"<Bar>echoh None<cr>
inorea tzset	tzset<c-o>:echoh HintHL<Bar>echo "void tzset (void)"<Bar>echoh None<cr>
inorea ualarm	ualarm<c-o>:echoh HintHL<Bar>echo "ualarm(unsigned int usecs, unsigned int interval)"<Bar>echoh None<cr>
inorea ualarm	ualarm<c-o>:echoh HintHL<Bar>echo "useconds_t ualarm(useconds_t usecs, useconds_t interval)"<Bar>echoh None<cr>
inorea Uil_continue_type	Uil_continue_type<c-o>:echoh HintHL<Bar>echo "Uil_command_type *command_desc, Uil_compile_desc_type **compile_desc, Uil_continue_type (*message_cb) (), char *message_data, Uil_continue_type (*status_cb) (), char *status_data)"<Bar>echoh None<cr>
inorea Uint32	Uint32<c-o>:echoh HintHL<Bar>echo "/* Function prototype for the timer callback function */ typedef Uint32 (*SDL_TimerCallback)(Uint32 interval)"<Bar>echoh None<cr>
inorea Uint32	Uint32<c-o>:echoh HintHL<Bar>echo "typedef Uint32 (*SDL_NewTimerCallback)(Uint32 interval, void *param)"<Bar>echoh None<cr>
inorea ulimit	ulimit<c-o>:echoh HintHL<Bar>echo "long ulimit(int cmd, long newlimit)"<Bar>echoh None<cr>
inorea unctrl	unctrl<c-o>:echoh HintHL<Bar>echo "char *unctrl(chtype c)"<Bar>echoh None<cr>
inorea ungetch	ungetch<c-o>:echoh HintHL<Bar>echo "int ungetch(int ch)"<Bar>echoh None<cr>
inorea ungetc	ungetc<c-o>:echoh HintHL<Bar>echo "int ungetc(int c, FILE * stream)"<Bar>echoh None<cr>
inorea ungetmouse	ungetmouse<c-o>:echoh HintHL<Bar>echo "int ungetmouse(MEVENT *event)"<Bar>echoh None<cr>
inorea unget_wch	unget_wch<c-o>:echoh HintHL<Bar>echo "int unget_wch(const wchar_t wch)"<Bar>echoh None<cr>
inorea ungetwc	ungetwc<c-o>:echoh HintHL<Bar>echo "wint_t ungetwc(wint_t wc, FILE * stream)"<Bar>echoh None<cr>
inorea unlockpt	unlockpt<c-o>:echoh HintHL<Bar>echo "int unlockpt(int fd)"<Bar>echoh None<cr>
inorea unpost_form	unpost_form<c-o>:echoh HintHL<Bar>echo "int unpost_form(FORM *form)"<Bar>echoh None<cr>
inorea unpost_menu	unpost_menu<c-o>:echoh HintHL<Bar>echo "int unpost_menu(MENU *menu)"<Bar>echoh None<cr>
inorea unreachable	unreachable<c-o>:echoh HintHL<Bar>echo " PvmHostFail host is unreachable (and thus possibly failed)"<Bar>echoh None<cr>
inorea unsetenv	unsetenv<c-o>:echoh HintHL<Bar>echo "int unsetenv(const char * name)"<Bar>echoh None<cr>
inorea untouchwin	untouchwin<c-o>:echoh HintHL<Bar>echo "int untouchwin(WINDOW *win)"<Bar>echoh None<cr>
inorea update_panels	update_panels<c-o>:echoh HintHL<Bar>echo "void update_panels()"<Bar>echoh None<cr>
inorea updwtmp	updwtmp<c-o>:echoh HintHL<Bar>echo "void updwtmp(const char * wtmp_file, const struct utmp * ut)"<Bar>echoh None<cr>
inorea use_env	use_env<c-o>:echoh HintHL<Bar>echo "void use_env(bool f)"<Bar>echoh None<cr>
inorea usleep	usleep<c-o>:echoh HintHL<Bar>echo "int usleep(useconds_t usec)"<Bar>echoh None<cr>
inorea usleep	usleep<c-o>:echoh HintHL<Bar>echo "void usleep(unsigned long usec)"<Bar>echoh None<cr>
inorea utmpname	utmpname<c-o>:echoh HintHL<Bar>echo "void utmpname(const char * file)"<Bar>echoh None<cr>
inorea uuid_clear	uuid_clear<c-o>:echoh HintHL<Bar>echo "void uuid_clear(uuid_t uu)"<Bar>echoh None<cr>
inorea uuid_compare	uuid_compare<c-o>:echoh HintHL<Bar>echo "int uuid_compare(uuid_t uu1, uuid_t uu2)"<Bar>echoh None<cr>
inorea uuid_copy	uuid_copy<c-o>:echoh HintHL<Bar>echo "void uuid_copy(uuid_t dst, uuid_t src)"<Bar>echoh None<cr>
inorea uuid_generate_random	uuid_generate_random<c-o>:echoh HintHL<Bar>echo "void uuid_generate_random(uuid_t out)"<Bar>echoh None<cr>
inorea uuid_generate_time	uuid_generate_time<c-o>:echoh HintHL<Bar>echo "void uuid_generate_time(uuid_t out)"<Bar>echoh None<cr>
inorea uuid_generate	uuid_generate<c-o>:echoh HintHL<Bar>echo "void uuid_generate(uuid_t out)"<Bar>echoh None<cr>
inorea uuid_is_null	uuid_is_null<c-o>:echoh HintHL<Bar>echo "int uuid_is_null(uuid_t uu)"<Bar>echoh None<cr>
inorea uuid_parse	uuid_parse<c-o>:echoh HintHL<Bar>echo "int uuid_parse( char * in, uuid_t uu)"<Bar>echoh None<cr>
inorea uuid_time	uuid_time<c-o>:echoh HintHL<Bar>echo "time_t uuid_time(uuid_t uu, struct timeval * ret_tv)"<Bar>echoh None<cr>
inorea uuid_unparse_lower	uuid_unparse_lower<c-o>:echoh HintHL<Bar>echo "void uuid_unparse_lower(uuid_t uu, char * out)"<Bar>echoh None<cr>
inorea uuid_unparse_upper	uuid_unparse_upper<c-o>:echoh HintHL<Bar>echo "void uuid_unparse_upper(uuid_t uu, char * out)"<Bar>echoh None<cr>
inorea uuid_unparse	uuid_unparse<c-o>:echoh HintHL<Bar>echo "void uuid_unparse(uuid_t uu, char * out)"<Bar>echoh None<cr>
inorea va_arg	va_arg<c-o>:echoh HintHL<Bar>echo " type va_arg(va_list ap, type)"<Bar>echoh None<cr>
inorea va_copy	va_copy<c-o>:echoh HintHL<Bar>echo "void va_copy(va_list dest, va_list src)"<Bar>echoh None<cr>
inorea va_end	va_end<c-o>:echoh HintHL<Bar>echo "void va_end(va_list ap)"<Bar>echoh None<cr>
inorea valloc	valloc<c-o>:echoh HintHL<Bar>echo "void * valloc (size_t size)"<Bar>echoh None<cr>
inorea valloc	valloc<c-o>:echoh HintHL<Bar>echo "void *valloc(size_t size)"<Bar>echoh None<cr>
inorea vasprintf	vasprintf<c-o>:echoh HintHL<Bar>echo "int vasprintf(char ** strp, const char * fmt, va_list ap)"<Bar>echoh None<cr>
inorea va_start	va_start<c-o>:echoh HintHL<Bar>echo "void va_start(va_list ap, last)"<Bar>echoh None<cr>
inorea vdprintf	vdprintf<c-o>:echoh HintHL<Bar>echo "int vdprintf(int fd, const char * format, va_list ap)"<Bar>echoh None<cr>
inorea versionsort	versionsort<c-o>:echoh HintHL<Bar>echo "int versionsort(const void * a, const void * b)"<Bar>echoh None<cr>
inorea vfprintf	vfprintf<c-o>:echoh HintHL<Bar>echo "int vfprintf(FILE * stream, const char * format, va_list ap)"<Bar>echoh None<cr>
inorea vfscanf	vfscanf<c-o>:echoh HintHL<Bar>echo "int vfscanf(FILE * stream, const char * format, va_list ap)"<Bar>echoh None<cr>
inorea vfwprintf	vfwprintf<c-o>:echoh HintHL<Bar>echo "int vfwprintf(FILE * stream, const wchar_t * format, va_list args)"<Bar>echoh None<cr>
inorea vid_attr	vid_attr<c-o>:echoh HintHL<Bar>echo "int vid_attr(attr_t attrs, short pair, void *opts)"<Bar>echoh None<cr>
inorea vidattr	vidattr<c-o>:echoh HintHL<Bar>echo "int vidattr(chtype attrs)"<Bar>echoh None<cr>
inorea vid_puts	vid_puts<c-o>:echoh HintHL<Bar>echo "int vid_puts(attr_t attrs, short pair, void *opts, int (*putc)(char))"<Bar>echoh None<cr>
inorea vidputs	vidputs<c-o>:echoh HintHL<Bar>echo "int vidputs(chtype attrs, int (*putc)(int))"<Bar>echoh None<cr>
inorea vline	vline<c-o>:echoh HintHL<Bar>echo "int vline(chtype ch, int n)"<Bar>echoh None<cr>
inorea voidne_addr_destroy	voidne_addr_destroy<c-o>:echoh HintHL<Bar>echo "voidne_addr_destroy(ne_sock_addr*addr)"<Bar>echoh None<cr>
inorea voidne_add_request_header	voidne_add_request_header<c-o>:echoh HintHL<Bar>echo "voidne_add_request_header(ne_request*request, constchar*name, constchar*value)"<Bar>echoh None<cr>
inorea voidne_buffer_altered	voidne_buffer_altered<c-o>:echoh HintHL<Bar>echo "voidne_buffer_altered(ne_buffer*buf)"<Bar>echoh None<cr>
inorea voidne_buffer_append	voidne_buffer_append<c-o>:echoh HintHL<Bar>echo "voidne_buffer_append(ne_buffer*buf, constchar*string, size_tlen)"<Bar>echoh None<cr>
inorea voidne_buffer_clear	voidne_buffer_clear<c-o>:echoh HintHL<Bar>echo "voidne_buffer_clear(ne_buffer*buf)"<Bar>echoh None<cr>
inorea voidne_buffer_destroy	voidne_buffer_destroy<c-o>:echoh HintHL<Bar>echo "voidne_buffer_destroy(ne_buffer*buf)"<Bar>echoh None<cr>
inorea voidne_buffer_grow	voidne_buffer_grow<c-o>:echoh HintHL<Bar>echo "voidne_buffer_grow(ne_buffer*buf, size_tsize)"<Bar>echoh None<cr>
inorea voidne_buffer_zappend	voidne_buffer_zappend<c-o>:echoh HintHL<Bar>echo "voidne_buffer_zappend(ne_buffer*buf, constchar*string)"<Bar>echoh None<cr>
inorea voidne_close_connection	voidne_close_connection<c-o>:echoh HintHL<Bar>echo "voidne_close_connection(ne_session*session)"<Bar>echoh None<cr>
inorea voidne_forget_auth	voidne_forget_auth<c-o>:echoh HintHL<Bar>echo "voidne_forget_auth(ne_session*session)"<Bar>echoh None<cr>
inorea voidne_iaddr_free	voidne_iaddr_free<c-o>:echoh HintHL<Bar>echo "voidne_iaddr_free(constne_inet_addr*ia)"<Bar>echoh None<cr>
inorea voidne_oom_callback	voidne_oom_callback<c-o>:echoh HintHL<Bar>echo "voidne_oom_callback(void(*callback)(void))"<Bar>echoh None<cr>
inorea voidne_request_destroy	voidne_request_destroy<c-o>:echoh HintHL<Bar>echo "voidne_request_destroy(ne_request*req)"<Bar>echoh None<cr>
inorea voidne_session_destroy	voidne_session_destroy<c-o>:echoh HintHL<Bar>echo "voidne_session_destroy(ne_session*session)"<Bar>echoh None<cr>
inorea voidne_session_proxy	voidne_session_proxy<c-o>:echoh HintHL<Bar>echo "voidne_session_proxy(ne_session*session, constchar*hostname, unsignedintport)"<Bar>echoh None<cr>
inorea voidne_set_persist	voidne_set_persist<c-o>:echoh HintHL<Bar>echo "voidne_set_persist(ne_session*session, intflag)"<Bar>echoh None<cr>
inorea voidne_set_proxy_auth	voidne_set_proxy_auth<c-o>:echoh HintHL<Bar>echo "voidne_set_proxy_auth(ne_session*session, ne_request_authcallback, void*userdata)"<Bar>echoh None<cr>
inorea voidne_set_read_timeout	voidne_set_read_timeout<c-o>:echoh HintHL<Bar>echo "voidne_set_read_timeout(ne_session*session, inttimeout)"<Bar>echoh None<cr>
inorea voidne_set_request_body_buffer	voidne_set_request_body_buffer<c-o>:echoh HintHL<Bar>echo "voidne_set_request_body_buffer(ne_request*req, constchar*buf, size_tcount)"<Bar>echoh None<cr>
inorea voidne_set_request_expect100	voidne_set_request_expect100<c-o>:echoh HintHL<Bar>echo "voidne_set_request_expect100(ne_request*request, intflag)"<Bar>echoh None<cr>
inorea voidne_set_server_auth	voidne_set_server_auth<c-o>:echoh HintHL<Bar>echo "voidne_set_server_auth(ne_session*session, ne_request_authcallback, void*userdata)"<Bar>echoh None<cr>
inorea voidne_set_useragent	voidne_set_useragent<c-o>:echoh HintHL<Bar>echo "voidne_set_useragent(ne_session*session, constchar*product)"<Bar>echoh None<cr>
inorea voidne_ssl_cert_free	voidne_ssl_cert_free<c-o>:echoh HintHL<Bar>echo "voidne_ssl_cert_free(ne_ssl_certificate*cert)"<Bar>echoh None<cr>
inorea voidne_ssl_clicert_free	voidne_ssl_clicert_free<c-o>:echoh HintHL<Bar>echo "voidne_ssl_clicert_free(ne_ssl_client_cert*ccert)"<Bar>echoh None<cr>
inorea voidne_ssl_set_verify	voidne_ssl_set_verify<c-o>:echoh HintHL<Bar>echo "voidne_ssl_set_verify(ne_session*session, ne_ssl_verify_fnverify_fn, void*userdata)"<Bar>echoh None<cr>
inorea voidne_ssl_trust_cert	voidne_ssl_trust_cert<c-o>:echoh HintHL<Bar>echo "voidne_ssl_trust_cert(ne_session*session, constne_ssl_certificate*cert)"<Bar>echoh None<cr>
inorea voidne_ssl_trust_default_ca	voidne_ssl_trust_default_ca<c-o>:echoh HintHL<Bar>echo "voidne_ssl_trust_default_ca(ne_session*session)"<Bar>echoh None<cr>
inorea voidne_xml_destroy	voidne_xml_destroy<c-o>:echoh HintHL<Bar>echo "voidne_xml_destroy(ne_xml_parser*parser)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo " FIELDTYPE *fieldtype, void *(* const make_arg)(va_list *), void *(* const copy_arg)(const void *), void (* const free_arg)(void *))"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "typedef void (*sighandler_t)(int)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "typedef void (*TIFFErrorHandler)(const char * module, const char * fmt, va_list ap)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "typedef void (*TIFFUnmapFileProc)(thandle_t, tdata_t, toff_t)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "typedef void (*TIFFWarningHandler)(const char * module, const char * fmt, va_list ap)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*__after_morecore_hook)(void)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*fatal_func) ()"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*)(FORM *) field_init(const FORM *form)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*)(FORM *) field_term(const FORM *form)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*)(FORM *) form_init(const FORM *form)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*)(FORM *) form_term(const FORM *form)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*__free_hook)(void * ptr, const void * caller)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*__malloc_initialize_hook)(void)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*)(MENU *) item_init(const MENU *menu)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*)(MENU *) item_term(const MENU *menu)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*)(MENU *) menu_init(const MENU *menu)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*)(MENU *) menu_term(const MENU *menu)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*pgout)(void *, pgno_t, void *), void *pgcookie)"<Bar>echoh None<cr>
inorea void	void<c-o>:echoh HintHL<Bar>echo "void (*proc) (const char *, long, const char *, va_list)"<Bar>echoh None<cr>
inorea vprintf	vprintf<c-o>:echoh HintHL<Bar>echo "int vprintf(const char * format, va_list ap)"<Bar>echoh None<cr>
inorea vscanf	vscanf<c-o>:echoh HintHL<Bar>echo "int vscanf(const char * format, va_list ap)"<Bar>echoh None<cr>
inorea vsnprintf	vsnprintf<c-o>:echoh HintHL<Bar>echo "int vsnprintf(char * str, size_t size, const char * format, va_list ap)"<Bar>echoh None<cr>
inorea vsprintf	vsprintf<c-o>:echoh HintHL<Bar>echo "int vsprintf(char * str, const char * format, va_list ap)"<Bar>echoh None<cr>
inorea vsscanf	vsscanf<c-o>:echoh HintHL<Bar>echo "int vsscanf(const char * str, const char * format, va_list ap)"<Bar>echoh None<cr>
inorea vswprintf	vswprintf<c-o>:echoh HintHL<Bar>echo "int vswprintf(wchar_t * wcs, size_t maxlen, const wchar_t * format, va_list args)"<Bar>echoh None<cr>
inorea vsyslog	vsyslog<c-o>:echoh HintHL<Bar>echo "void vsyslog(int priority, const char * format, va_list ap)"<Bar>echoh None<cr>
inorea vwprintf	vwprintf<c-o>:echoh HintHL<Bar>echo "int vwprintf(const wchar_t * format, va_list args)"<Bar>echoh None<cr>
inorea vw_printw	vw_printw<c-o>:echoh HintHL<Bar>echo "int vw_printw(WINDOW *win, const char *fmt, va_list varglist)"<Bar>echoh None<cr>
inorea vwprintw	vwprintw<c-o>:echoh HintHL<Bar>echo "int vwprintw(WINDOW *win, const char *fmt, va_list varglist)"<Bar>echoh None<cr>
inorea vw_scanw	vw_scanw<c-o>:echoh HintHL<Bar>echo "int vw_scanw(WINDOW *win, char *fmt, va_list varglist)"<Bar>echoh None<cr>
inorea vwscanw	vwscanw<c-o>:echoh HintHL<Bar>echo "int vwscanw(WINDOW *win, char *fmt, va_list varglist)"<Bar>echoh None<cr>
inorea waddchnstr	waddchnstr<c-o>:echoh HintHL<Bar>echo "int waddchnstr(WINDOW *win, const chtype *chstr, int n)"<Bar>echoh None<cr>
inorea waddchstr	waddchstr<c-o>:echoh HintHL<Bar>echo "int waddchstr(WINDOW *win, const chtype *chstr)"<Bar>echoh None<cr>
inorea waddch	waddch<c-o>:echoh HintHL<Bar>echo "int waddch(WINDOW *win, const chtype ch)"<Bar>echoh None<cr>
inorea waddnstr	waddnstr<c-o>:echoh HintHL<Bar>echo "int waddnstr(WINDOW *win, const char *str, int n)"<Bar>echoh None<cr>
inorea waddnwstr	waddnwstr<c-o>:echoh HintHL<Bar>echo "int waddnwstr(WINDOW *win, const wchar_t *wstr, int n)"<Bar>echoh None<cr>
inorea waddstr	waddstr<c-o>:echoh HintHL<Bar>echo "int waddstr(WINDOW *win, const char *str)"<Bar>echoh None<cr>
inorea wadd_wchnstr	wadd_wchnstr<c-o>:echoh HintHL<Bar>echo "int wadd_wchnstr(WINDOW * win, const cchar_t *wchstr, int n)"<Bar>echoh None<cr>
inorea wadd_wchstr	wadd_wchstr<c-o>:echoh HintHL<Bar>echo "int wadd_wchstr(WINDOW * win, const cchar_t *wchstr)"<Bar>echoh None<cr>
inorea wadd_wch	wadd_wch<c-o>:echoh HintHL<Bar>echo "int wadd_wch( WINDOW *win\fP, const cchar_t *wch)"<Bar>echoh None<cr>
inorea waddwstr	waddwstr<c-o>:echoh HintHL<Bar>echo "int waddwstr(WINDOW *win, const wchar_t *wstr)"<Bar>echoh None<cr>
inorea wattr_get	wattr_get<c-o>:echoh HintHL<Bar>echo "int wattr_get(WINDOW *win, attr_t *attrs, short *pair, void *opts)"<Bar>echoh None<cr>
inorea wattr_off	wattr_off<c-o>:echoh HintHL<Bar>echo "int wattr_off(WINDOW *win, attr_t attrs, void *opts)"<Bar>echoh None<cr>
inorea wattroff	wattroff<c-o>:echoh HintHL<Bar>echo "int wattroff(WINDOW *win, int attrs)"<Bar>echoh None<cr>
inorea wattr_on	wattr_on<c-o>:echoh HintHL<Bar>echo "int wattr_on(WINDOW *win, attr_t attrs, void *opts)"<Bar>echoh None<cr>
inorea wattron	wattron<c-o>:echoh HintHL<Bar>echo "int wattron(WINDOW *win, int attrs)"<Bar>echoh None<cr>
inorea wattr_set	wattr_set<c-o>:echoh HintHL<Bar>echo "int wattr_set(WINDOW *win, attr_t attrs, short pair, void *opts)"<Bar>echoh None<cr>
inorea wattrset	wattrset<c-o>:echoh HintHL<Bar>echo "int wattrset(WINDOW *win, int attrs)"<Bar>echoh None<cr>
inorea wbkgdset	wbkgdset<c-o>:echoh HintHL<Bar>echo "void wbkgdset(WINDOW *win, chtype ch)"<Bar>echoh None<cr>
inorea wbkgd	wbkgd<c-o>:echoh HintHL<Bar>echo "int wbkgd(WINDOW *win, chtype ch)"<Bar>echoh None<cr>
inorea wbkgrndset	wbkgrndset<c-o>:echoh HintHL<Bar>echo "void wbkgrndset(WINDOW *win, const cchar_t *wch)"<Bar>echoh None<cr>
inorea wbkgrnd	wbkgrnd<c-o>:echoh HintHL<Bar>echo "int wbkgrnd( WINDOW *win, const cchar_t *wch)"<Bar>echoh None<cr>
inorea wborder	wborder<c-o>:echoh HintHL<Bar>echo "int wborder(WINDOW *win, chtype ls, chtype rs, chtype ts, chtype bs, chtype tl, chtype tr, chtype bl, chtype br)"<Bar>echoh None<cr>
inorea wchgat	wchgat<c-o>:echoh HintHL<Bar>echo "int wchgat(WINDOW *win, int n, attr_t attr, short color, const void *opts)"<Bar>echoh None<cr>
inorea wclear	wclear<c-o>:echoh HintHL<Bar>echo "int wclear(WINDOW *win)"<Bar>echoh None<cr>
inorea wclrtobot	wclrtobot<c-o>:echoh HintHL<Bar>echo "int wclrtobot(WINDOW *win)"<Bar>echoh None<cr>
inorea wclrtoeol	wclrtoeol<c-o>:echoh HintHL<Bar>echo "int wclrtoeol(WINDOW *win)"<Bar>echoh None<cr>
inorea wcolor_set	wcolor_set<c-o>:echoh HintHL<Bar>echo "int wcolor_set(WINDOW *win, short color_pair_number, void* opts)"<Bar>echoh None<cr>
inorea wcpcpy	wcpcpy<c-o>:echoh HintHL<Bar>echo "wchar_t *wcpcpy(wchar_t * dest, const wchar_t * src)"<Bar>echoh None<cr>
inorea wcpncpy	wcpncpy<c-o>:echoh HintHL<Bar>echo "wchar_t *wcpncpy(wchar_t * dest, const wchar_t * src, size_t n)"<Bar>echoh None<cr>
inorea wcrtomb	wcrtomb<c-o>:echoh HintHL<Bar>echo "size_t wcrtomb(char * s, wchar_t wc, mbstate_t * ps)"<Bar>echoh None<cr>
inorea wcscasecmp	wcscasecmp<c-o>:echoh HintHL<Bar>echo "int wcscasecmp(const wchar_t * s1, const wchar_t * s2)"<Bar>echoh None<cr>
inorea wcscat	wcscat<c-o>:echoh HintHL<Bar>echo "wchar_t *wcscat(wchar_t * dest, const wchar_t * src)"<Bar>echoh None<cr>
inorea wcschr	wcschr<c-o>:echoh HintHL<Bar>echo "wchar_t *wcschr(const wchar_t * wcs, wchar_t wc)"<Bar>echoh None<cr>
inorea wcscmp	wcscmp<c-o>:echoh HintHL<Bar>echo "int wcscmp(const wchar_t * s1, const wchar_t * s2)"<Bar>echoh None<cr>
inorea wcscpy	wcscpy<c-o>:echoh HintHL<Bar>echo "wchar_t *wcscpy(wchar_t * dest, const wchar_t * src)"<Bar>echoh None<cr>
inorea wcscspn	wcscspn<c-o>:echoh HintHL<Bar>echo "size_t wcscspn(const wchar_t * wcs, const wchar_t * reject)"<Bar>echoh None<cr>
inorea wcsdup	wcsdup<c-o>:echoh HintHL<Bar>echo "wchar_t *wcsdup(const wchar_t * s)"<Bar>echoh None<cr>
inorea wcslen	wcslen<c-o>:echoh HintHL<Bar>echo "size_t wcslen(const wchar_t * s)"<Bar>echoh None<cr>
inorea wcsncasecmp	wcsncasecmp<c-o>:echoh HintHL<Bar>echo "int wcsncasecmp(const wchar_t * s1, const wchar_t * s2, size_t n)"<Bar>echoh None<cr>
inorea wcsncat	wcsncat<c-o>:echoh HintHL<Bar>echo "wchar_t *wcsncat(wchar_t * dest, const wchar_t * src, size_t n)"<Bar>echoh None<cr>
inorea wcsncmp	wcsncmp<c-o>:echoh HintHL<Bar>echo "int wcsncmp(const wchar_t * s1, const wchar_t * s2, size_t n)"<Bar>echoh None<cr>
inorea wcsncpy	wcsncpy<c-o>:echoh HintHL<Bar>echo "wchar_t *wcsncpy(wchar_t * dest, const wchar_t * src, size_t n)"<Bar>echoh None<cr>
inorea wcsnlen	wcsnlen<c-o>:echoh HintHL<Bar>echo "size_t wcsnlen(const wchar_t * s, size_t maxlen)"<Bar>echoh None<cr>
inorea wcsnrtombs	wcsnrtombs<c-o>:echoh HintHL<Bar>echo "size_t wcsnrtombs(char * dest, const wchar_t ** src, size_t nwc, size_t len, mbstate_t * ps)"<Bar>echoh None<cr>
inorea wcspbrk	wcspbrk<c-o>:echoh HintHL<Bar>echo "wchar_t *wcspbrk(const wchar_t * wcs, const wchar_t * accept)"<Bar>echoh None<cr>
inorea wcsrchr	wcsrchr<c-o>:echoh HintHL<Bar>echo "wchar_t *wcsrchr(const wchar_t * wcs, wchar_t wc)"<Bar>echoh None<cr>
inorea wcsrtombs	wcsrtombs<c-o>:echoh HintHL<Bar>echo "size_t wcsrtombs(char * dest, const wchar_t ** src, size_t len, mbstate_t * ps)"<Bar>echoh None<cr>
inorea wcsspn	wcsspn<c-o>:echoh HintHL<Bar>echo "wcsspn(const wchar_t * wcs, const wchar_t * accept)"<Bar>echoh None<cr>
inorea wcsstr	wcsstr<c-o>:echoh HintHL<Bar>echo "wchar_t *wcsstr(const wchar_t * haystack, const wchar_t * needle)"<Bar>echoh None<cr>
inorea wcstoimax	wcstoimax<c-o>:echoh HintHL<Bar>echo "intmax_t wcstoimax (const wchar_t * nptr, wchar_t ** endptr, int base)"<Bar>echoh None<cr>
inorea wcstok	wcstok<c-o>:echoh HintHL<Bar>echo "wchar_t *wcstok(wchar_t * wcs, const wchar_t * delim, wchar_t ** ptr)"<Bar>echoh None<cr>
inorea wcstombs	wcstombs<c-o>:echoh HintHL<Bar>echo "size_t wcstombs(char * dest, const wchar_t * src, size_t n)"<Bar>echoh None<cr>
inorea wcswidth	wcswidth<c-o>:echoh HintHL<Bar>echo "int wcswidth(const wchar_t * s, size_t n)"<Bar>echoh None<cr>
inorea wctob	wctob<c-o>:echoh HintHL<Bar>echo "int wctob(wint_t c)"<Bar>echoh None<cr>
inorea wctomb	wctomb<c-o>:echoh HintHL<Bar>echo "int wctomb(char * s, wchar_t wc)"<Bar>echoh None<cr>
inorea wctrans	wctrans<c-o>:echoh HintHL<Bar>echo "wctrans_t wctrans(const char * name)"<Bar>echoh None<cr>
inorea wctype	wctype<c-o>:echoh HintHL<Bar>echo "wctype_t wctype(const char * name)"<Bar>echoh None<cr>
inorea wcursyncup	wcursyncup<c-o>:echoh HintHL<Bar>echo "void wcursyncup(WINDOW *win)"<Bar>echoh None<cr>
inorea wcwidth	wcwidth<c-o>:echoh HintHL<Bar>echo "int wcwidth(wchar_t c)"<Bar>echoh None<cr>
inorea wdelch	wdelch<c-o>:echoh HintHL<Bar>echo "int wdelch(WINDOW *win)"<Bar>echoh None<cr>
inorea wdeleteln	wdeleteln<c-o>:echoh HintHL<Bar>echo "int wdeleteln(WINDOW *win)"<Bar>echoh None<cr>
inorea wechochar	wechochar<c-o>:echoh HintHL<Bar>echo "int wechochar(WINDOW *win, const chtype ch)"<Bar>echoh None<cr>
inorea wecho_wchar	wecho_wchar<c-o>:echoh HintHL<Bar>echo "int wecho_wchar( WINDOW *win\fP, const cchar_t *wch)"<Bar>echoh None<cr>
inorea wenclose	wenclose<c-o>:echoh HintHL<Bar>echo "bool wenclose(const WINDOW *win, int y, int x)"<Bar>echoh None<cr>
inorea werase	werase<c-o>:echoh HintHL<Bar>echo "int werase(WINDOW *win)"<Bar>echoh None<cr>
inorea wgetbkgrnd	wgetbkgrnd<c-o>:echoh HintHL<Bar>echo "int wgetbkgrnd(WINDOW *win, cchar_t *wch)"<Bar>echoh None<cr>
inorea wgetch	wgetch<c-o>:echoh HintHL<Bar>echo "int wgetch(WINDOW *win)"<Bar>echoh None<cr>
inorea wgetnstr	wgetnstr<c-o>:echoh HintHL<Bar>echo "int wgetnstr(WINDOW *win, char *str, int n)"<Bar>echoh None<cr>
inorea wgetn_wstr	wgetn_wstr<c-o>:echoh HintHL<Bar>echo "int wgetn_wstr(WINDOW *win, wint_t *wstr, int n)"<Bar>echoh None<cr>
inorea wgetstr	wgetstr<c-o>:echoh HintHL<Bar>echo "int wgetstr(WINDOW *win, char *str)"<Bar>echoh None<cr>
inorea wget_wch	wget_wch<c-o>:echoh HintHL<Bar>echo "int wget_wch(WINDOW *win, wint_t *wch)"<Bar>echoh None<cr>
inorea wget_wstr	wget_wstr<c-o>:echoh HintHL<Bar>echo "int wget_wstr(WINDOW *win, wint_t *wstr)"<Bar>echoh None<cr>
inorea whline	whline<c-o>:echoh HintHL<Bar>echo "int whline(WINDOW *win, chtype ch, int n)"<Bar>echoh None<cr>
inorea Widget	Widget<c-o>:echoh HintHL<Bar>echo "MrmType class_code, String class_name, String create_name, Widget (*create_proc) (), WidgetClass class_record)"<Bar>echoh None<cr>
inorea winchnstr	winchnstr<c-o>:echoh HintHL<Bar>echo "int winchnstr(WINDOW *win, chtype *chstr, int n)"<Bar>echoh None<cr>
inorea winchstr	winchstr<c-o>:echoh HintHL<Bar>echo "int winchstr(WINDOW *win, chtype *chstr)"<Bar>echoh None<cr>
inorea winch	winch<c-o>:echoh HintHL<Bar>echo "chtype winch(WINDOW *win)"<Bar>echoh None<cr>
inorea winnstr	winnstr<c-o>:echoh HintHL<Bar>echo "int winnstr(WINDOW *win, char *str, int n)"<Bar>echoh None<cr>
inorea winnwstr	winnwstr<c-o>:echoh HintHL<Bar>echo "int winnwstr(WINDOW *win, wchar_t *str, int n)"<Bar>echoh None<cr>
inorea winsch	winsch<c-o>:echoh HintHL<Bar>echo "int winsch(WINDOW *win, chtype ch)"<Bar>echoh None<cr>
inorea winsdelln	winsdelln<c-o>:echoh HintHL<Bar>echo "int winsdelln(WINDOW *win, int n)"<Bar>echoh None<cr>
inorea winsertln	winsertln<c-o>:echoh HintHL<Bar>echo "int winsertln(WINDOW *win)"<Bar>echoh None<cr>
inorea winsnstr	winsnstr<c-o>:echoh HintHL<Bar>echo "int winsnstr(WINDOW *win, const char *str, int n)"<Bar>echoh None<cr>
inorea wins_nwstr	wins_nwstr<c-o>:echoh HintHL<Bar>echo "int wins_nwstr(WINDOW *win, const wchar_t *wstr, int n)"<Bar>echoh None<cr>
inorea winsstr	winsstr<c-o>:echoh HintHL<Bar>echo "int winsstr(WINDOW *win, const char *str)"<Bar>echoh None<cr>
inorea winstr	winstr<c-o>:echoh HintHL<Bar>echo "int winstr(WINDOW *win, char *str)"<Bar>echoh None<cr>
inorea wins_wch	wins_wch<c-o>:echoh HintHL<Bar>echo "int wins_wch(WINDOW *win, const cchar_t *wch)"<Bar>echoh None<cr>
inorea wins_wstr	wins_wstr<c-o>:echoh HintHL<Bar>echo "int wins_wstr(WINDOW *win, const wchar_t *wstr)"<Bar>echoh None<cr>
inorea win_wchnstr	win_wchnstr<c-o>:echoh HintHL<Bar>echo "int win_wchnstr(WINDOW *win, cchar_t *wchstr, int n)"<Bar>echoh None<cr>
inorea win_wchstr	win_wchstr<c-o>:echoh HintHL<Bar>echo "int win_wchstr(WINDOW *win, cchar_t *wchstr)"<Bar>echoh None<cr>
inorea win_wch	win_wch<c-o>:echoh HintHL<Bar>echo "int win_wch(WINDOW *win, cchar_t *wcval)"<Bar>echoh None<cr>
inorea winwstr	winwstr<c-o>:echoh HintHL<Bar>echo "int winwstr(WINDOW *win, wchar_t *str)"<Bar>echoh None<cr>
inorea wmemchr	wmemchr<c-o>:echoh HintHL<Bar>echo "wchar_t *wmemchr(const wchar_t * s, wchar_t c, size_t n)"<Bar>echoh None<cr>
inorea wmemcmp	wmemcmp<c-o>:echoh HintHL<Bar>echo "int wmemcmp(const wchar_t * s1, const wchar_t * s2, size_t n)"<Bar>echoh None<cr>
inorea wmemcpy	wmemcpy<c-o>:echoh HintHL<Bar>echo "wchar_t *wmemcpy(wchar_t * dest, const wchar_t * src, size_t n)"<Bar>echoh None<cr>
inorea wmemmove	wmemmove<c-o>:echoh HintHL<Bar>echo "wchar_t *wmemmove(wchar_t * dest, const wchar_t * src, size_t n)"<Bar>echoh None<cr>
inorea wmempcpy	wmempcpy<c-o>:echoh HintHL<Bar>echo "wchar_t *wmempcpy(wchar_t * dest, const wchar_t * src, size_t n)"<Bar>echoh None<cr>
inorea wmemset	wmemset<c-o>:echoh HintHL<Bar>echo "wchar_t *wmemset(wchar_t * wcs, wchar_t wc, size_t n)"<Bar>echoh None<cr>
inorea wmouse_trafo	wmouse_trafo<c-o>:echoh HintHL<Bar>echo "bool wmouse_trafo(const WINDOW* win, int* pY, int* pX, bool to_screen)"<Bar>echoh None<cr>
inorea wmove	wmove<c-o>:echoh HintHL<Bar>echo "int wmove(WINDOW *win, int y, int x)"<Bar>echoh None<cr>
inorea wnoutrefresh	wnoutrefresh<c-o>:echoh HintHL<Bar>echo "int wnoutrefresh(WINDOW *win)"<Bar>echoh None<cr>
inorea wordexp	wordexp<c-o>:echoh HintHL<Bar>echo "int wordexp(const char * s, wordexp_t * p, int flags)"<Bar>echoh None<cr>
inorea wordfree	wordfree<c-o>:echoh HintHL<Bar>echo "void wordfree(wordexp_t * p)"<Bar>echoh None<cr>
inorea wprintf	wprintf<c-o>:echoh HintHL<Bar>echo "int wprintf(const wchar_t * format, ...)"<Bar>echoh None<cr>
inorea wprintw	wprintw<c-o>:echoh HintHL<Bar>echo "int wprintw(WINDOW *win, const char *fmt, ...)"<Bar>echoh None<cr>
inorea wredrawln	wredrawln<c-o>:echoh HintHL<Bar>echo "int wredrawln(WINDOW *win, int beg_line, int num_lines)"<Bar>echoh None<cr>
inorea wrefresh	wrefresh<c-o>:echoh HintHL<Bar>echo "int wrefresh(WINDOW *win)"<Bar>echoh None<cr>
inorea wresize	wresize<c-o>:echoh HintHL<Bar>echo "int wresize(WINDOW *win, int lines, int columns)"<Bar>echoh None<cr>
inorea wscanw	wscanw<c-o>:echoh HintHL<Bar>echo "int wscanw(WINDOW *win, char *fmt, ...)"<Bar>echoh None<cr>
inorea wscrl	wscrl<c-o>:echoh HintHL<Bar>echo "int wscrl(WINDOW *win, int n)"<Bar>echoh None<cr>
inorea wsetscrreg	wsetscrreg<c-o>:echoh HintHL<Bar>echo "int wsetscrreg(WINDOW *win, int top, int bot)"<Bar>echoh None<cr>
inorea wstandend	wstandend<c-o>:echoh HintHL<Bar>echo "int wstandend(WINDOW *win)"<Bar>echoh None<cr>
inorea wstandout	wstandout<c-o>:echoh HintHL<Bar>echo "int wstandout(WINDOW *win)"<Bar>echoh None<cr>
inorea wsyncdown	wsyncdown<c-o>:echoh HintHL<Bar>echo "void wsyncdown(WINDOW *win)"<Bar>echoh None<cr>
inorea wsyncup	wsyncup<c-o>:echoh HintHL<Bar>echo "void wsyncup(WINDOW *win)"<Bar>echoh None<cr>
inorea wtimeout	wtimeout<c-o>:echoh HintHL<Bar>echo "void wtimeout(WINDOW *win, int delay)"<Bar>echoh None<cr>
inorea wtouchln	wtouchln<c-o>:echoh HintHL<Bar>echo "int wtouchln(WINDOW *win, int y, int n, int changed)"<Bar>echoh None<cr>
inorea wunctrl	wunctrl<c-o>:echoh HintHL<Bar>echo "char *wunctrl(cchar_t *c)"<Bar>echoh None<cr>
inorea wvline	wvline<c-o>:echoh HintHL<Bar>echo "int wvline(WINDOW *win, chtype ch, int n)"<Bar>echoh None<cr>
inorea X509_NAME_add_entry_by_NID	X509_NAME_add_entry_by_NID<c-o>:echoh HintHL<Bar>echo "int X509_NAME_add_entry_by_NID(X509_NAME *name, int nid, int type, unsigned char *bytes, int len, int loc, int set)"<Bar>echoh None<cr>
inorea X509_NAME_add_entry_by_OBJ	X509_NAME_add_entry_by_OBJ<c-o>:echoh HintHL<Bar>echo "int X509_NAME_add_entry_by_OBJ(X509_NAME *name, \s-1ASN1_OBJECT\s0 *obj, int type, unsigned char *bytes, int len, int loc, int set)"<Bar>echoh None<cr>
inorea X509_NAME_add_entry_by_txt	X509_NAME_add_entry_by_txt<c-o>:echoh HintHL<Bar>echo "int X509_NAME_add_entry_by_txt(X509_NAME *name, const char *field, int type, const unsigned char *bytes, int len, int loc, int set)"<Bar>echoh None<cr>
inorea X509_NAME_add_entry	X509_NAME_add_entry<c-o>:echoh HintHL<Bar>echo "int X509_NAME_add_entry(X509_NAME *name,X509_NAME_ENTRY *ne, int loc, int set)"<Bar>echoh None<cr>
inorea X509_NAME_delete_entry	X509_NAME_delete_entry<c-o>:echoh HintHL<Bar>echo "X509_NAME_ENTRY *X509_NAME_delete_entry(X509_NAME *name, int loc)"<Bar>echoh None<cr>
inorea X509_NAME_entry_count	X509_NAME_entry_count<c-o>:echoh HintHL<Bar>echo "int X509_NAME_entry_count(X509_NAME *name)"<Bar>echoh None<cr>
inorea X509_NAME_ENTRY_create_by_NID	X509_NAME_ENTRY_create_by_NID<c-o>:echoh HintHL<Bar>echo "X509_NAME_ENTRY *X509_NAME_ENTRY_create_by_NID(X509_NAME_ENTRY **ne, int nid, int type,unsigned char *bytes, int len)"<Bar>echoh None<cr>
inorea X509_NAME_ENTRY_create_by_OBJ	X509_NAME_ENTRY_create_by_OBJ<c-o>:echoh HintHL<Bar>echo "X509_NAME_ENTRY *X509_NAME_ENTRY_create_by_OBJ(X509_NAME_ENTRY **ne, \s-1ASN1_OBJECT\s0 *obj, int type, const unsigned char *bytes, int len)"<Bar>echoh None<cr>
inorea X509_NAME_ENTRY_create_by_txt	X509_NAME_ENTRY_create_by_txt<c-o>:echoh HintHL<Bar>echo "X509_NAME_ENTRY *X509_NAME_ENTRY_create_by_txt(X509_NAME_ENTRY **ne, const char *field, int type, const unsigned char *bytes, int len)"<Bar>echoh None<cr>
inorea X509_NAME_ENTRY_set_data	X509_NAME_ENTRY_set_data<c-o>:echoh HintHL<Bar>echo "int X509_NAME_ENTRY_set_data(X509_NAME_ENTRY *ne, int type, const unsigned char *bytes, int len)"<Bar>echoh None<cr>
inorea X509_NAME_ENTRY_set_object	X509_NAME_ENTRY_set_object<c-o>:echoh HintHL<Bar>echo "int X509_NAME_ENTRY_set_object(X509_NAME_ENTRY *ne, \s-1ASN1_OBJECT\s0 *obj)"<Bar>echoh None<cr>
inorea X509_NAME_get_entry	X509_NAME_get_entry<c-o>:echoh HintHL<Bar>echo "X509_NAME_ENTRY *X509_NAME_get_entry(X509_NAME *name, int loc)"<Bar>echoh None<cr>
inorea X509_NAME_get_index_by_NID	X509_NAME_get_index_by_NID<c-o>:echoh HintHL<Bar>echo "int X509_NAME_get_index_by_NID(X509_NAME *name,int nid,int lastpos)"<Bar>echoh None<cr>
inorea X509_NAME_get_index_by_OBJ	X509_NAME_get_index_by_OBJ<c-o>:echoh HintHL<Bar>echo "int X509_NAME_get_index_by_OBJ(X509_NAME *name,ASN1_OBJECT *obj, int lastpos)"<Bar>echoh None<cr>
inorea X509_NAME_get_text_by_NID	X509_NAME_get_text_by_NID<c-o>:echoh HintHL<Bar>echo "int X509_NAME_get_text_by_NID(X509_NAME *name, int nid, char *buf,int len)"<Bar>echoh None<cr>
inorea X509_NAME_get_text_by_OBJ	X509_NAME_get_text_by_OBJ<c-o>:echoh HintHL<Bar>echo "int X509_NAME_get_text_by_OBJ(X509_NAME *name, \s-1ASN1_OBJECT\s0 *obj, char *buf,int len)"<Bar>echoh None<cr>
inorea xdecrypt	xdecrypt<c-o>:echoh HintHL<Bar>echo "int xdecrypt (char * secret, char * passwd)"<Bar>echoh None<cr>
inorea xencrypt	xencrypt<c-o>:echoh HintHL<Bar>echo "int xencrypt (char * secret, char * passwd)"<Bar>echoh None<cr>
inorea XeviGetVisualInfo	XeviGetVisualInfo<c-o>:echoh HintHL<Bar>echo "XeviGetVisualInfo (Display *dpy, VisualID *visual, int n_visual, ExtendedVisualInfo ** evi_return, int * n_info_return)"<Bar>echoh None<cr>
inorea XeviQueryExtension	XeviQueryExtension<c-o>:echoh HintHL<Bar>echo "XeviQueryExtension (Display *dpy)"<Bar>echoh None<cr>
inorea XeviQueryVersion	XeviQueryVersion<c-o>:echoh HintHL<Bar>echo "XeviQueryVersion (Display *dpy, int *major_version_return, int *minor_version_return)"<Bar>echoh None<cr>
inorea XmClipboardCancelCopy	XmClipboardCancelCopy<c-o>:echoh HintHL<Bar>echo "int XmClipboardCancelCopy (display, window, item_id\fP)"<Bar>echoh None<cr>
inorea XmClipboardCopyByName	XmClipboardCopyByName<c-o>:echoh HintHL<Bar>echo "int XmClipboardCopyByName (display, window, data_id, buffer, length, private_id\fP)"<Bar>echoh None<cr>
inorea XmClipboardCopy	XmClipboardCopy<c-o>:echoh HintHL<Bar>echo "int XmClipboardCopy (display, window, item_id, format_name, buffer, length, private_id, data_id\fP)"<Bar>echoh None<cr>
inorea XmClipboardEndCopy	XmClipboardEndCopy<c-o>:echoh HintHL<Bar>echo "int XmClipboardEndCopy (display, window, item_id\fP)"<Bar>echoh None<cr>
inorea XmClipboardEndRetrieve	XmClipboardEndRetrieve<c-o>:echoh HintHL<Bar>echo "int XmClipboardEndRetrieve (display, window\fP)"<Bar>echoh None<cr>
inorea XmClipboardInquireCount	XmClipboardInquireCount<c-o>:echoh HintHL<Bar>echo "int XmClipboardInquireCount (display, window, count, max_format_name_length\fP)"<Bar>echoh None<cr>
inorea XmClipboardInquireFormat	XmClipboardInquireFormat<c-o>:echoh HintHL<Bar>echo "int XmClipboardInquireFormat (display, window, index, format_name_buf, buffer_len, copied_len\fP)"<Bar>echoh None<cr>
inorea XmClipboardInquireLength	XmClipboardInquireLength<c-o>:echoh HintHL<Bar>echo "int XmClipboardInquireLength (display, window, format_name, length\fP)"<Bar>echoh None<cr>
inorea XmClipboardInquirePendingItems	XmClipboardInquirePendingItems<c-o>:echoh HintHL<Bar>echo "int XmClipboardInquirePendingItems (display, window, format_name, item_list, count\fP)"<Bar>echoh None<cr>
inorea XmClipboardLock	XmClipboardLock<c-o>:echoh HintHL<Bar>echo "int XmClipboardLock (display, window\fP)"<Bar>echoh None<cr>
inorea XmClipboardRegisterFormat	XmClipboardRegisterFormat<c-o>:echoh HintHL<Bar>echo "int XmClipboardRegisterFormat (display, format_name, format_length\fP)"<Bar>echoh None<cr>
inorea XmClipboardRetrieve	XmClipboardRetrieve<c-o>:echoh HintHL<Bar>echo "int XmClipboardRetrieve (display, window, format_name, buffer, length, num_bytes, private_id\fP)"<Bar>echoh None<cr>
inorea XmClipboardStartCopy	XmClipboardStartCopy<c-o>:echoh HintHL<Bar>echo "int XmClipboardStartCopy (display, window, clip_label, timestamp, widget, callback, item_id\fP)"<Bar>echoh None<cr>
inorea XmClipboardStartRetrieve	XmClipboardStartRetrieve<c-o>:echoh HintHL<Bar>echo "int XmClipboardStartRetrieve (display, window, timestamp\fP)"<Bar>echoh None<cr>
inorea XmClipboardUndoCopy	XmClipboardUndoCopy<c-o>:echoh HintHL<Bar>echo "int XmClipboardUndoCopy (display, window\fP)"<Bar>echoh None<cr>
inorea XmClipboardUnlock	XmClipboardUnlock<c-o>:echoh HintHL<Bar>echo "int XmClipboardUnlock (display, window, remove_all_locks\fP)"<Bar>echoh None<cr>
inorea XmClipboardWithdrawFormat	XmClipboardWithdrawFormat<c-o>:echoh HintHL<Bar>echo "int XmClipboardWithdrawFormat (display, window, data_id\fP)"<Bar>echoh None<cr>
inorea XmCvtTextPropertyToXmStringTable	XmCvtTextPropertyToXmStringTable<c-o>:echoh HintHL<Bar>echo "int XmCvtTextPropertyToXmStringTable (display, text_prop, string_table_return, count_return\fP)"<Bar>echoh None<cr>
inorea XmCvtXmStringTableToTextProperty	XmCvtXmStringTableToTextProperty<c-o>:echoh HintHL<Bar>echo "int XmCvtXmStringTableToTextProperty (display, string_table, count, style, text_prop_return\fP)"<Bar>echoh None<cr>
inorea XmDirectionMatchPartial	XmDirectionMatchPartial<c-o>:echoh HintHL<Bar>echo "Boolean XmDirectionMatchPartial (d1, d2, dmask\fP)"<Bar>echoh None<cr>
inorea XmDirectionMatch	XmDirectionMatch<c-o>:echoh HintHL<Bar>echo "Boolean XmDirectionMatch (d1, d2\fP)"<Bar>echoh None<cr>
inorea XmDirectionToStringDirection	XmDirectionToStringDirection<c-o>:echoh HintHL<Bar>echo "XmStringDirection XmDirectionToStringDirection (dir\fP)"<Bar>echoh None<cr>
inorea XmScrollBarGetValues	XmScrollBarGetValues<c-o>:echoh HintHL<Bar>echo "void XmScrollBarGetValues (widget, value_return, slider_size_return, increment_return, page_increment_return\fP)"<Bar>echoh None<cr>
inorea XmScrollBarSetValues	XmScrollBarSetValues<c-o>:echoh HintHL<Bar>echo "void XmScrollBarSetValues (widget, value, slider_size, increment, page_increment, notify\fP)"<Bar>echoh None<cr>
inorea XmStringByteStreamLength	XmStringByteStreamLength<c-o>:echoh HintHL<Bar>echo "unsigned int XmStringByteStreamLength (string\fP)"<Bar>echoh None<cr>
inorea XmUpdateDisplay	XmUpdateDisplay<c-o>:echoh HintHL<Bar>echo "void XmUpdateDisplay (widget\fP)"<Bar>echoh None<cr>
inorea XResQueryClientPixmapBytes	XResQueryClientPixmapBytes<c-o>:echoh HintHL<Bar>echo "Status XResQueryClientPixmapBytes(Display *dpy\fP, XID xid\fP, unsigned long *bytes\fP\^)"<Bar>echoh None<cr>
inorea XResQueryClientResources	XResQueryClientResources<c-o>:echoh HintHL<Bar>echo "Status XResQueryClientResources(Display *dpy\fP, XID xid\fP, int *num_types\fP, XResType **types\fP\^)"<Bar>echoh None<cr>
inorea XResQueryClients	XResQueryClients<c-o>:echoh HintHL<Bar>echo "Status XResQueryClients(Display *dpy\fP, int *num_clients\fP, XResClient **clients\fP\^)"<Bar>echoh None<cr>
inorea XResQueryExtension	XResQueryExtension<c-o>:echoh HintHL<Bar>echo "Bool XResQueryExtension(Display *dpy\fP, int *event_basep\fP, int *error_basep\fP\^)"<Bar>echoh None<cr>
inorea XResQueryVersion	XResQueryVersion<c-o>:echoh HintHL<Bar>echo "Status XResQueryVersion(Display *dpy\fP, int *major_versionp\fP, int *minor_versionp\fP\^)"<Bar>echoh None<cr>
inorea XScreenSaverAllocInfo	XScreenSaverAllocInfo<c-o>:echoh HintHL<Bar>echo "XScreenSaverInfo *XScreenSaverAllocInfo(\^void\^)"<Bar>echoh None<cr>
inorea XScreenSaverGetRegistered	XScreenSaverGetRegistered<c-o>:echoh HintHL<Bar>echo "Status XScreenSaverGetRegistered(Display *dpy\fP, int screen\fP, XID *xid\fP, Atom *type\fP\^)"<Bar>echoh None<cr>
inorea XScreenSaverQueryExtension	XScreenSaverQueryExtension<c-o>:echoh HintHL<Bar>echo "Bool XScreenSaverQueryExtension(Display *dpy\fP, int *event_basep\fP, int *error_basep\fP\^)"<Bar>echoh None<cr>
inorea XScreenSaverQueryInfo	XScreenSaverQueryInfo<c-o>:echoh HintHL<Bar>echo "Status XScreenSaverQueryInfo(\^Display *dpy\fP, Drawable drawable\fP, XScreenSaverInfo *saver_info\fP\^)"<Bar>echoh None<cr>
inorea XScreenSaverQueryVersion	XScreenSaverQueryVersion<c-o>:echoh HintHL<Bar>echo "Status XScreenSaverQueryVersion(Display *dpy\fP, int *major_versionp\fP, int *minor_versionp\fP\^)"<Bar>echoh None<cr>
inorea XScreenSaverSaverRegister	XScreenSaverSaverRegister<c-o>:echoh HintHL<Bar>echo "void XScreenSaverSaverRegister(Display *dpy\fP, int screen\fP, XID xid\fP, Atom type\fP\^)"<Bar>echoh None<cr>
inorea XScreenSaverSelectInput	XScreenSaverSelectInput<c-o>:echoh HintHL<Bar>echo "void XScreenSaverSelectInput(Display *dpy\fP, Drawable drawable\fP, unsigned long mask\fp\^)"<Bar>echoh None<cr>
inorea XScreenSaverUnregister	XScreenSaverUnregister<c-o>:echoh HintHL<Bar>echo "Status XScreenSaverUnregister(Display *dpy\fP, int screen\fP\^)"<Bar>echoh None<cr>
inorea XScreenSaverUnsetAttributes	XScreenSaverUnsetAttributes<c-o>:echoh HintHL<Bar>echo "void XScreenSaverUnsetAttributes(Display *dpy\fP, Drawable drawable\fP\^)"<Bar>echoh None<cr>
inorea y0f	y0f<c-o>:echoh HintHL<Bar>echo "float y0f(float x)"<Bar>echoh None<cr>
inorea y0l	y0l<c-o>:echoh HintHL<Bar>echo "long double y0l(long double x)"<Bar>echoh None<cr>
inorea y0	y0<c-o>:echoh HintHL<Bar>echo "double y0(double x)"<Bar>echoh None<cr>
inorea y1f	y1f<c-o>:echoh HintHL<Bar>echo "float y1f(float x)"<Bar>echoh None<cr>
inorea y1l	y1l<c-o>:echoh HintHL<Bar>echo "long double y1l(long double x)"<Bar>echoh None<cr>
inorea y1	y1<c-o>:echoh HintHL<Bar>echo "double y1(double x)"<Bar>echoh None<cr>
inorea ynf	ynf<c-o>:echoh HintHL<Bar>echo "float ynf(int n, float x)"<Bar>echoh None<cr>
inorea ynl	ynl<c-o>:echoh HintHL<Bar>echo "long double ynl(int n, long double x)"<Bar>echoh None<cr>
inorea yn	yn<c-o>:echoh HintHL<Bar>echo "double yn(int n, double x)"<Bar>echoh None<cr>

" ---------------------------------------------------------------------
"  Highlighting Control: {{{1
" if the "HintHL" highlighting group hasn't been defined, then this function will define it
fun! s:HLTEST(hlname)
  let id_hlname= hlID(a:hlname)
  let fg_hlname= string(synIDattr(synIDtrans(hlID(a:hlname)),"fg"))
  if id_hlname == 0 || fg_hlname == "0" || fg_hlname == "-1"
   return 0
  endif
  return 1
endfun
if !s:HLTEST("HintHL")
 if &bg == "dark"
  hi HintHL ctermfg=blue ctermbg=white guifg=blue3 guibg=white
 else
  hi HintHL ctermfg=white ctermbg=blue guifg=white guibg=blue3
 endif
endif
delf s:HLTEST

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker
