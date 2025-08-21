(function () {
    'use strict';

    const loop_urls = {
        local: 'https://localhost:33000/pun/sys/loop/connect/dataverse/external_tool_dataset',
        cannon_prod: 'https://rcood.rc.fas.harvard.edu/pun/sys/loop/connect/dataverse/external_tool_dataset'
    };

    const params = new URLSearchParams(window.location.search);
    let env = 'local';

    for (const [key] of params.entries()) {
        if (key.startsWith('env_')) {
            env = key.substring(4); // 'env_local' => 'local'
            break;
        }
    }

    const dataverseUrl = params.get('dataverse_url');
    const datasetId = params.get('dataset_id');

    if (!dataverseUrl || !datasetId) {
        // HIDE THE LOOP EXPLORE DATASET LINK
        document.getElementById('loop_explore').style.display = 'none';
        return;
    }

    // HIDE THE LOOP HOMEPAGE LINK
    document.getElementById('loop_homepage').style.display = 'none';
    const base = loop_urls[env];
    const query = params.toString();

    document.getElementById('loop_explore').href = base + (query ? '?' + query : '');

    // Back to Dataverse link
    const backEl = document.getElementById('back');
    const backLink = `${dataverseUrl.replace(/\/$/, '')}/dataset.xhtml?persistentId=${encodeURIComponent(datasetId)}`;
    backEl.href = backLink;
})();
