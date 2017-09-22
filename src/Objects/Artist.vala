/*-
 * Copyright (c) 2017-2017 Artem Anufrij <artem.anufrij@live.de>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * The Noise authors hereby grant permission for non-GPL compatible
 * GStreamer plugins to be used and distributed together with GStreamer
 * and Noise. This permission is above and beyond the permissions granted
 * by the GPL license by which Noise is covered. If you modify this code
 * you may extend this exception to your version of the code, but you are not
 * obligated to do so. If you do not wish to do so, delete this exception
 * statement from your version.
 *
 * Authored by: Artem Anufrij <artem.anufrij@live.de>
 */

namespace PlayMyMusic.Objects {
    public class Artist : GLib.Object {
        public int ID { get; set; }
        public string name { get; set; }

        GLib.List<Album> _albums;
        public GLib.List<Album> albums {
            get {
                if (_albums == null) {
                    _albums = PlayMyMusic.Services.LibraryManager.instance.db_manager.get_album_collection (this);
                }
                return _albums;
            }
        }

        construct {
            this._albums = new GLib.List<Album> ();
        }

        public void add_album (Album album) {
            album.set_artist (this);
            lock (this._albums) {
                this._albums.append (album);
            }
        }

        public void remove_album (Album album) {
            this._albums.remove (album);
        }

        public Album? get_album_by_title (string title) {
            Album? return_value = null;
            lock (_albums) {
                foreach (var album in albums) {
                    if (album.title == title) {
                        return_value = album;
                        break;
                    }
                }
            }
            return return_value;
        }
    }
}
