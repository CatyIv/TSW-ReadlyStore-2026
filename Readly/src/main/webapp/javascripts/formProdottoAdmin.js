function confermaRipristinoBackup(nomeFile, isbnCorrente) {
    if (confirm("Vuoi ripristinare questa copertina precedente? Quella attuale verrà salvata nello storico.")) {
        var formRestore = document.getElementById("formRestoreBackupHidden");
        var inputIsbn = document.getElementById("hiddenRestoreIsbn");
        var inputFileName = document.getElementById("hiddenRestoreFileName");

        if (formRestore && inputIsbn && inputFileName) {
            inputIsbn.value = isbnCorrente;
            inputFileName.value = nomeFile;

            formRestore.submit();
        }
    }
}