<?php
	$bad_keywords = ['input', 'flag', 'FLAG'];

	// On créer un fichier temporaire
	$tex_file = tmpfile();
	//Check for the bad keywords
	$tex_content = $_POST['latex'];
	foreach ($bad_keywords as $bad) {
		if (strpos($tex_content, $bad) !== false) {
			print("/error.php?error_name=Error 420&error=Bad keyword, \"$bad\" is forbidden !");
			exit();
		}
	}

	// On le stocke dans un fichier
    fwrite($tex_file, $_POST['latex']);
	// On compile le fichier pour récupérer le PDF
    $path = stream_get_meta_data($tex_file)['uri'];
	shell_exec("pdflatex -output-directory=pdfs -shell-escape -interaction=nonstopmode $path");
	// On supprime le fichier LaTeX
    fclose($tex_file);
	// Et les fichiers plus vieux qu'une minute
	shell_exec('find pdfs -mmin +1 -type f -delete -not -path \'*/\\.*\'');

	// Si la compilation n'a pas fonctionnée on redirige la personne vers les logs
    $pdf_id = basename($path);
	if (file_exists("pdfs/$pdf_id.pdf")) {
		// On redirige la personne vers le PDF
		print("/pdfs/$pdf_id.pdf");
		exit();
	} else {
		// On redirige la personne vers les logs
		print("/pdfs/$pdf_id.log");
		exit();
	}
