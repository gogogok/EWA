package com.example.EWA_backend.Controllers;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/youtube")
public class YouTubePlayerController {

    @GetMapping(value = "/player", produces = MediaType.TEXT_HTML_VALUE)
    public String player(@RequestParam String videoId) {

        String html = """
    <!DOCTYPE html>
    <html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            html, body, #player {
                margin: 0;
                padding: 0;
                width: 100%;
                height: 100%;
                background: black;
                overflow: hidden;
            }
        </style>
    </head>
    <body>
        <div id="player"></div>

        <script src="https://www.youtube.com/iframe_api"></script>

        <script>
            var player;

            function onYouTubeIframeAPIReady() {
                player = new YT.Player('player', {
                    width: '100%',
                    height: '100%',
                    videoId: 'VIDEO_ID_PLACEHOLDER',
                    playerVars: {
                        playsinline: 1,
                        controls: 1,
                        rel: 0,
                        enablejsapi: 1,
                        origin: window.location.origin
                    }
                });
            }

            function playVideo() {
                if (player) player.playVideo();
            }

            function pauseVideo() {
                if (player) player.pauseVideo();
            }

            function seekVideo(seconds) {
                if (player) player.seekTo(seconds, true);
            }

            function getCurrentTime() {
                return player ? player.getCurrentTime() : 0;
            }
        </script>
    </body>
    </html>
    """;

        return html.replace("VIDEO_ID_PLACEHOLDER", videoId);
    }
}