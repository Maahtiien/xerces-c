dnl @synopsis XERCES_CURL_PREFIX
dnl
dnl Determines the prefix for libcurl
dnl
dnl @category C
dnl @author James Berry
dnl @version 2005-05-23
dnl @license AllPermissive
dnl
dnl $Id$

AC_DEFUN([XERCES_CURL_PREFIX],
	[
	AC_ARG_WITH([curl],
		[AS_HELP_STRING([--with-curl[[[[=DIR]]]]],[Specify location of libcurl])],
		[
                  if test x"$with_curl" = x"yes"; then
                    with_curl=
                  fi
                ],
		[with_curl=])

	# Determine if curl is available
	AC_CACHE_VAL([xerces_cv_curl_present],
	[
		xerces_cv_curl_present=no
		if test x"$with_curl" != x"no"; then

                  # See if we were given a prefix.
                  #
		  if test -n "$with_curl"; then
                    AC_PATH_PROG([curl_config], [curl-config],[],[$with_curl/bin])
                  else
                    AC_PATH_PROG([curl_config], [curl-config],[])
                  fi

                  if test -n "$curl_config"; then
                    curl_flags=`$curl_config --cflags`
		    curl_libs=`$curl_config --libs`
                  else
                    if test -n "$with_curl"; then
                      curl_flags="-I$with_curl/include"
     		      curl_libs="-L$with_curl/lib -lcurl"
                    else
                      # Default compiler paths.
                      #
                      curl_flags=
     		      curl_libs=-lcurl
                    fi
                  fi

                  # Check that the headers exist and can be compiled.
                  #
                  orig_cppflags=$CPPFLAGS
                  if test -n "$curl_flags"; then
		    CPPFLAGS="$curl_flags $CPPFLAGS"
                  fi
                  AC_CHECK_HEADER([curl/curl.h], [xerces_cv_curl_present=yes])
		  CPPFLAGS=$orig_cppflags

                  if test x"$xerces_cv_curl_present" != x"no"; then
                    # Check that the library can be linked.
                    #
                    orig_ldflags=$LDFLAGS
		    LDFLAGS="$curl_libs $LDFLAGS"
                    AC_CHECK_LIB([curl], [curl_multi_init], [], [xerces_cv_curl_present=no])
		    LDFLAGS=$orig_ldflags
                  fi
		fi
	])

        AC_CACHE_VAL([xerces_cv_curl_flags], [xerces_cv_curl_flags=$curl_flags])
	AC_CACHE_VAL([xerces_cv_curl_libs], [xerces_cv_curl_libs=$curl_libs])

	AC_SUBST([CURL_PRESENT], [$xerces_cv_curl_present])
	AC_SUBST([CURL_FLAGS], [$xerces_cv_curl_flags])
	AC_SUBST([CURL_LIBS], [$xerces_cv_curl_libs])
	]
)
