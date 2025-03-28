/// The time an admin has to cancel a cross-sector message
#define CROSS_SECTOR_CANCEL_TIME (10 SECONDS)

/// The extended time an admin has to cancel a cross-sector message if they pass the filter, for instance
#define EXTENDED_CROSS_SECTOR_CANCEL_TIME (30 SECONDS)

//Security levels affect the escape shuttle timer
/// Security level is green. (no threats)
#define SEC_LEVEL_GREEN 0
/// Security level is blue. (caution advised)
#define SEC_LEVEL_BLUE 1
/// Security level is red. (hostile threats)
#define SEC_LEVEL_RED 2

// BANDASTATION ADDITION - START
/// Security level is gamma.
#define SEC_LEVEL_GAMMA 3
/// Security level is epsilon.
#define SEC_LEVEL_EPSILON 4
// BANDASTATION ADDITION - START

/// Security level is delta. (station destruction immiment)
#define SEC_LEVEL_DELTA 5 // BANDASTION EDIT: 3 => 5
