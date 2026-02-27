![](assets/douban.png)
# doumark

[![Build Status](https://github.com/haeward/doumark/actions/workflows/release.yml/badge.svg)](https://github.com/haeward/doumark/actions/workflows/release.yml)

Douban movie/book/music/game marked data sync for:
- GitHub Actions (`uses: haeward/doumark@...`)
- Docker/CLI (`docker run ...`)
- Drone pipelines (`image: haeward/doumark`)

> Migration update (2026-02-27): `drone-doumark` has been merged into this repository. New changes should go to `haeward/doumark`.

## Configuration

Core fields:
- `id`: Douban user ID
- `type`: `movie`, `book`, `music`, `game` (default `movie`)
- `status`: `mark`, `doing`, `done` (default `done`)
- `format`: `csv`, `json`, `notion`, `neodb` (default `csv`)
- `dir`: output path for `csv/json`, Notion database ID for `notion`
- `notion_token`: Notion integration token
- `neodb_token`: NeoDB access token

Environment variable compatibility is preserved:
- `INPUT_*` for GitHub Actions
- `PLUGIN_*` and `DOUBAN_*` for Docker/Drone

Examples:
- `INPUT_ID` / `PLUGIN_ID` / `DOUBAN_ID`
- `INPUT_FORMAT` / `PLUGIN_FORMAT` / `DOUBAN_FORMAT`
- `INPUT_NOTION_TOKEN` / `PLUGIN_NOTION_TOKEN` / `DOUBAN_NOTION_TOKEN`
- `INPUT_NEODB_TOKEN` / `PLUGIN_NEODB_TOKEN` / `DOUBAN_NEODB_TOKEN`

## GitHub Actions

See [action.yml](action.yml) for all inputs.

### Sync to CSV

```yml
name: douban
on:
  schedule:
    - cron: "30 * * * *"

jobs:
  douban:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: movie
        uses: haeward/doumark@master
        with:
          id: lizheming
          type: movie
          format: csv
          dir: ./data/douban

      - name: music
        uses: haeward/doumark@master
        with:
          id: lizheming
          type: music
          format: csv
          dir: ./data/douban

      - uses: EndBug/add-and-commit@v9
        with:
          message: "chore: update douban data"
          add: "./data/douban"
```

### Sync to Notion

```yml
- name: sync notion
  uses: haeward/doumark@master
  with:
    id: lizheming
    type: movie
    format: notion
    dir: <notion_database_id>
    notion_token: ${{ secrets.NOTION_TOKEN }}
```

### Sync to NeoDB

```yml
- name: sync neodb
  uses: haeward/doumark@master
  with:
    id: lizheming
    type: movie
    format: neodb
    neodb_token: ${{ secrets.NEODB_TOKEN }}
```

## Docker and Drone

### Docker

```bash
docker run --rm \
  -e PLUGIN_ID=lizheming \
  -e PLUGIN_TYPE=movie \
  -e PLUGIN_FORMAT=csv \
  -e PLUGIN_DIR=./data/douban \
  haeward/doumark:latest
```

### Drone

```yml
kind: pipeline
type: docker
name: default

steps:
  - name: douban
    image: haeward/doumark:latest
    settings:
      id: lizheming
      type: movie
      format: csv
      dir: ./data/douban
```

## Output Notes

- CSV output includes `type` classification:
  - `movie` -> `Movies`
  - `tv` -> `Series/Anime` (classified as `Anime` only if `genres` contains `动画`)
- JSON incremental cursor uses `star_time`; historical rows can fall back to `create_time`.

## Development

```bash
npm ci
npm run build
```

## Migration from `drone-doumark`

- Runtime behavior and supported env names are unchanged.
- Source code now lives in one repo: `haeward/doumark`.
- Legacy image tags can be kept temporarily, but new releases should use `haeward/doumark`.
