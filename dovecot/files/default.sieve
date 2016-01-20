require ["variables", "envelope", "fileinto", "subaddress"];
if header :contains "X-Spam-Level" "**********" {
  discard;
  stop;
} elsif header :contains "X-Spam-Flag" "YES" {
  fileinto "Junk";
  stop;
}

if envelope :matches :detail "to" "*" {
    /* Save name in ${name} in all lowercase except for the first letter.
     * Joe, joe, jOe thus all become 'Joe'.
     */
    set :lower :upperfirst "name" "${1}";
}
if string :is "${name}" "" {
    /* Default case if no detail is specified */
    fileinto "INBOX";
} else {
    /* For sales+joe@ this will become Joe */
    fileinto "${name}";
}
