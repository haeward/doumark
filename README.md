# doumark

![Douban](assets/douban.png)

[![Build Status](https://github.com/haeward/doumark/actions/workflows/release.yml/badge.svg)](https://github.com/haeward/doumark/actions/workflows/release.yml)

Douban movie/book/music/game marked data sync for:

- GitHub Actions (`uses: haeward/doumark@...`)

## Configuration

Core fields:

- `id`: Douban user ID
- `type`: `movie`, `book`, `music`, `game` (default `movie`)
- `status`: `mark`, `doing`, `done` (default `done`)
- `format`: `csv`, `json`, `notion`, `neodb` (default `csv`)
- `dir`: output path for `csv/json`, Notion database ID for `notion`
- `notion_token`: Notion integration token
- `neodb_token`: NeoDB access token

Environment variables for GitHub Actions:

- `INPUT_*`

Examples:

- `INPUT_ID`
- `INPUT_FORMAT`
- `INPUT_NOTION_TOKEN`
- `INPUT_NEODB_TOKEN`

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
        uses: haeward/doumark@main
        with:
          id: haeward
          type: movie
          format: csv
          dir: ./data/douban

      - name: music
        uses: haeward/doumark@main
        with:
          id: haeward
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
  uses: haeward/doumark@main
  with:
    id: haeward
    type: movie
    format: notion
    dir: <notion_database_id>
    notion_token: ${{ secrets.NOTION_TOKEN }}
```

### Sync to NeoDB

```yml
- name: sync neodb
  uses: haeward/doumark@main
  with:
    id: haeward
    type: movie
    format: neodb
    neodb_token: ${{ secrets.NEODB_TOKEN }}
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
