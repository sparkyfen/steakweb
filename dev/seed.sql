-- =====================================================================
-- dev/seed.sql  --  Sample data for manual testing (DEV ONLY)
-- =====================================================================
-- All rows are owned by the dev user.  The /dev/login route (gated behind
-- STEAKWEB_DEV) logs you in as this same userid, so these rows show up on
-- the homepage "My Extensions" list as well as (when published) on the
-- public /directory page.
--
--   DEV USERID = 1010   (matches the /dev/login dev session uid)
--
-- What each row is here to prove:
--   * Several PUBLISHED rows across prefixes 2/3/5/6  -> appear on /directory
--   * One UNPUBLISHED row (4040)                      -> hidden from /directory
--   * One name with HTML metacharacters (5050)        -> proves HTML escaping
--   * One out-of-range "legacy" number (8888)         -> lists fine, but the
--                                                        create form rejects
--                                                        new 8xxx numbers
--   * A documented DUPLICATE target (2345)            -> re-create it via the
--                                                        Add Extension form to
--                                                        hit the "already taken"
--                                                        path (UniqueViolation)
--
-- >>> To reproduce the "already taken" error: log in via /dev/login, then in
-- >>> the Add Extension form submit extension 2345 (any name). It already
-- >>> exists, so you should get the friendly "already taken" message, NOT a 500.
-- =====================================================================

-- switch 11 is the SIP switch (steakweb.py hardcodes switch = 11 for SIP)
INSERT INTO switches (id, type, address_type, name) VALUES
    (11, 'sip', 'sipv4', 'Dev SIP switch');
SELECT setval('switches_id_seq', 11);

INSERT INTO registered_extensions (extn, name, userid, auth_code, publish, switch, provisioned) VALUES
    (2345, 'Dev Test Line',                              1010, '000000000001', true,  NULL, true),  -- duplicate target
    (2600, 'Phreak Hotline',                             1010, '000000000002', true,    11, true),  -- SIP (switch=11)
    (3141, 'Pi Information Line',                         1010, '000000000003', true,  NULL, true),
    (4040, 'Hidden Back Office',                          1010, '000000000004', false, NULL, true),  -- UNPUBLISHED -> hidden
    (5050, '<script>alert(''xss'')</script> & "Bobby"',  1010, '000000000005', true,  NULL, true),  -- HTML metachars
    (6999, 'Edge Of Range',                              1010, '000000000006', true,  NULL, true),
    (8888, 'Legacy Trunk (out of range)',                1010, '000000000007', true,  NULL, true);  -- out-of-range legacy
