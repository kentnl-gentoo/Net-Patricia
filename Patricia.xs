#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

#include "libpatricia/patricia.h"

static int
not_here(s)
char *s;
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

static double
constant(name, arg)
char *name;
int arg;
{
    errno = 0;
    switch (*name) {
    case 'A':
	break;
    case 'B':
	break;
    case 'C':
	break;
    case 'D':
	break;
    case 'E':
	break;
    case 'F':
	break;
    case 'G':
	break;
    case 'H':
	break;
    case 'I':
	break;
    case 'J':
	break;
    case 'K':
	break;
    case 'L':
	break;
    case 'M':
	break;
    case 'N':
	break;
    case 'O':
	break;
    case 'P':
	break;
    case 'Q':
	break;
    case 'R':
	break;
    case 'S':
	break;
    case 'T':
	break;
    case 'U':
	break;
    case 'V':
	break;
    case 'W':
	break;
    case 'X':
	break;
    case 'Y':
	break;
    case 'Z':
	break;
    case 'a':
	break;
    case 'b':
	break;
    case 'c':
	break;
    case 'd':
	break;
    case 'e':
	break;
    case 'f':
	break;
    case 'g':
	break;
    case 'h':
	break;
    case 'i':
	break;
    case 'j':
	break;
    case 'k':
	break;
    case 'l':
	break;
    case 'm':
	break;
    case 'n':
	break;
    case 'o':
	break;
    case 'p':
	break;
    case 'q':
	break;
    case 'r':
	break;
    case 's':
	break;
    case 't':
	break;
    case 'u':
	break;
    case 'v':
	break;
    case 'w':
	break;
    case 'x':
	break;
    case 'y':
	break;
    case 'z':
	break;
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static void deref_data(SV *data) {
   SvREFCNT_dec(data);
   data = (void *)0;
}

typedef patricia_tree_t *Net__Patricia;
typedef patricia_node_t *Net__PatriciaNode;

MODULE = Net::Patricia		PACKAGE = Net::Patricia

PROTOTYPES: ENABLE

double
constant(name,arg)
	char *		name
	int		arg

Net::Patricia
new(class)
	char *				class
	CODE:
		RETVAL = New_Patricia(32); /* FIXME for AF_INET6 */
	OUTPUT:	
		RETVAL

void
add_string(tree, string, ...)
	Net::Patricia			tree
	char *				string
	PROTOTYPE: $$;$
	PREINIT:
		/* FIXME for AF_INET6: */
	   	prefix_t *prefix;
	   	Net__PatriciaNode node;
	PPCODE:
	   	prefix = ascii2prefix(AF_INET, string);
	   	node = patricia_lookup(tree, prefix);
	   	Deref_Prefix(prefix);
		if ((patricia_node_t *)0 != node) {
		   /* { */
		   node->data = ST(items-1);
		   SvREFCNT_inc(ST(items-1));
		   /* } */
		   PUSHs(sv_mortalcopy((SV *)node->data));
		} else {
		   XSRETURN_UNDEF;
		}

void
match_string(tree, string)
	Net::Patricia			tree
	char *				string
	PPCODE:
		{
		   /* FIXME for AF_INET6: */
		   patricia_node_t *node
		    = patricia_search_best(tree, ascii2prefix(AF_INET, string));
                   if ((patricia_node_t *)0 != node) {
		      XPUSHs(sv_mortalcopy((SV *)node->data));
		   } else {
		      XSRETURN_UNDEF;
		   }
		}

void
match_exact_string(tree, string)
	Net::Patricia			tree
	char *				string
	PPCODE:
		{
		   /* FIXME for AF_INET6: */
		   patricia_node_t *node
		   = patricia_search_exact(tree, ascii2prefix(AF_INET, string));
                   if ((patricia_node_t *)0 != node) {
		      XPUSHs(sv_mortalcopy((SV *)node->data));
		   } else {
		      XSRETURN_UNDEF;
		   }
		}

void
match_integer(tree, integer)
	Net::Patricia			tree
	unsigned long			integer
	PPCODE:
		{
		   patricia_node_t *node;
		   prefix_t prefix;
		   unsigned long netlong = htonl(integer);
		   memcpy(&prefix.add.sin, &netlong, sizeof netlong);
		   prefix.family = AF_INET; /* FIXME for AF_INET6 */
		   prefix.bitlen = 32; /* FIXME for AF_INET6 */
		   prefix.ref_count = 0;
		   node = patricia_search_best(tree, &prefix);
                   if ((patricia_node_t *)0 != node) {
		      XPUSHs(sv_mortalcopy((SV *)node->data));
		   } else {
		      XSRETURN_UNDEF;
		   }
		}

void
match_exact_integer(tree, integer, ...)
	Net::Patricia			tree
	unsigned long			integer
	PPCODE:
		{
		   patricia_node_t *node = (patricia_node_t *)0;
		   prefix_t prefix;
		   unsigned long netlong = htonl(integer);
		   memcpy(&prefix.add.sin, &netlong, sizeof netlong);
		   prefix.family = AF_INET; /* FIXME for AF_INET6 */
		   if (items == 3) {
		      prefix.bitlen = SvIV(ST(2));
		      if (prefix.bitlen > 32) { /* FIXME for AF_INET6 */
                         croak("mask length must be <= 32");
		      }
		   } else if (items > 3) {
	              croak("Usage: Net::Patricia::match_exact_integer(tree,integer[,mask_length])");
		   } else {
		      prefix.bitlen = 32; /* FIXME for AF_INET6 */
		   }
		   prefix.ref_count = 0;
		   node = patricia_search_exact(tree, &prefix);
                   if ((patricia_node_t *)0 != node) {
		      XPUSHs(sv_mortalcopy((SV *)node->data));
		   } else {
		      XSRETURN_UNDEF;
		   }
		}

void
remove_string(tree, string)
	Net::Patricia			tree
	char *				string
	PPCODE:
		{
		   /* FIXME for AF_INET6: */
	   	   prefix_t *prefix = ascii2prefix(AF_INET, string);
	   	   Net__PatriciaNode node = patricia_search_exact(tree, prefix);
		   if ((Net__PatriciaNode)0 != node) {
		      XPUSHs(sv_mortalcopy((SV *)node->data));
		      deref_data(node->data);
		      patricia_remove(tree, node);
		   } else {
		      XSRETURN_UNDEF;
		   }
		}

size_t
climb(tree, ...)
	Net::Patricia			tree
	PREINIT:
		patricia_node_t *node = (patricia_node_t *)0;
		size_t n = 0;
		SV *func = (SV *)0;
	CODE:
		if (2 == items) {
		   func = ST(1);
		} else if (2 < items) {
	           croak("Usage: Net::Patricia::climb(tree[,CODEREF])");
		}
		PATRICIA_WALK (tree->head, node) {
		   if ((SV *)0 != func) {
		      PUSHMARK(sp);
		      XPUSHs(sv_mortalcopy((SV *)node->data));
		      PUTBACK;
		      perl_call_sv(func, G_VOID|G_DISCARD);
		      SPAGAIN;
		   }
		   n++;
		} PATRICIA_WALK_END;
		RETVAL = n;
	OUTPUT:	
		RETVAL

void
DESTROY(tree)
	Net::Patricia			tree
	CODE:
	Destroy_Patricia(tree, deref_data);
